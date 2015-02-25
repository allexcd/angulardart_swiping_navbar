// Fix for Phonegap issue regarding "Relative URL resolution requires a valid base URI" throw error.
// See line 32
library angular.core_dom.resource_url_resolver.wrapper;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/core_dom/type_to_uri_mapper.dart';

class _NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}

@Injectable()
class ResourceUrlResolver2 implements ResourceUrlResolver {
  static final RegExp cssUrlRegexp = new RegExp(r'''(\burl\((?:[\s]+)?)(['"]?)([\S]*)(\2(?:[\s]+)?\))''');
  static final RegExp cssImportRegexp = new RegExp(r'(@import[\s]+(?!url\())([^;]*)(;)');
  static const List<String> urlAttrs = const ['href', 'src', 'action'];
  static final String urlAttrsSelector = '[${urlAttrs.join('],[')}]';
  static final RegExp urlTemplateSearch = new RegExp('{{.*}}');
  static final RegExp quotes = new RegExp("[\"\']");

  // Reconstruct the Uri without the http or https restriction due to Uri.base.origin
  final _baseUri = _getBaseUri();

  final TypeToUriMapper _uriMapper;
  final ResourceResolverConfig _config;

  ResourceUrlResolver2(this._uriMapper, this._config);

  static final NodeTreeSanitizer _nullTreeSanitizer = new _NullTreeSanitizer();
  static final docForParsing = document.implementation.createHtmlDocument('');

  // TODO: another solution must be found, cleaner than this
  // Overriding _getBaseUri method by removing if conditional to always return the value.
  // This fixes Phonegap issue regarding "Relative URL resolution requires a valid base URI" throw error
  // See "packages/angular/core_dom/resource_url_resolver.dart" file for the original _getBaseUri() statement
  static String _getBaseUri() {
    return "${Uri.base.scheme}://${Uri.base.authority}/";
  }

  static Element _parseHtmlString(String html) {
    var div = docForParsing.createElement('div');
    div.setInnerHtml(html, treeSanitizer: _nullTreeSanitizer);
    return div;
  }

  String resolveHtml(String html, [Uri baseUri]) {
    if (baseUri == null) {
      return html;
    }
    Element elem = _parseHtmlString(html);
    _resolveDom(elem, baseUri);
    return elem.innerHtml;
  }

  /**
   * Resolves all relative URIs within the DOM from being relative to
   * [originalBase] to being absolute.
   */
  void _resolveDom(Node root, Uri baseUri) {
    _resolveAttributes(root, baseUri);
    _resolveStyles(root, baseUri);

    // handle template.content
    for (var template in _querySelectorAll(root, 'template')) {
      if (template.content != null) {
        _resolveDom(template.content, baseUri);
      }
    }
  }

  Iterable<Element> _querySelectorAll(Node node, String selectors) {
    if (node is DocumentFragment) {
      return node.querySelectorAll(selectors);
    }
    if (node is Element) {
      return node.querySelectorAll(selectors);
    }
    return const [];
  }

  void _resolveStyles(Node node, Uri baseUri) {
    var styles = _querySelectorAll(node, 'style');
    for (var style in styles) {
      _resolveStyle(style, baseUri);
    }
  }

  void _resolveStyle(StyleElement style, Uri baseUri) {
    style.text = resolveCssText(style.text, baseUri);
  }

  String resolveCssText(String cssText, Uri baseUri) {
    cssText = _replaceUrlsInCssText(cssText, baseUri, cssUrlRegexp);
    return _replaceUrlsInCssText(cssText, baseUri, cssImportRegexp);
  }

  void _resolveAttributes(Node root, Uri baseUri) {
    if (root is Element) {
      _resolveElementAttributes(root, baseUri);
    }

    for (var node in _querySelectorAll(root, urlAttrsSelector)) {
      _resolveElementAttributes(node, baseUri);
    }
  }

  void _resolveElementAttributes(Element element, Uri baseUri) {
    var attrs = element.attributes;
    for (var attr in urlAttrs) {
      if (attrs.containsKey(attr)) {
        var value = attrs[attr];
        if (!value.contains(urlTemplateSearch)) {
          attrs[attr] = combine(baseUri, value).toString();
        }
      }
    }
  }

  String _replaceUrlsInCssText(String cssText, Uri baseUri, RegExp regexp) {
    return cssText.replaceAllMapped(regexp, (match) {
      var url = match[3].trim();
      var urlPath = combine(baseUri, url).toString();
      return '${match[1].trim()}${match[2]}${urlPath}${match[2]})';
    });
  }
  /// Combines a type-based URI with a relative URI.
  ///
  /// [baseUri] is assumed to use package: syntax for package-relative
  /// URIs, while [uri] is assumed to use 'packages/' syntax for
  /// package-relative URIs. Resulting URIs will use 'packages/' to indicate
  /// package-relative URIs.
  String combine(Uri baseUri, String uri) {
    if (!_config.useRelativeUrls) {
      return uri;
    }

    if (uri == null) {
      uri = baseUri.path;
    } else {
      // if it's absolute but not package-relative, then just use that
      // The "packages/" test is just for backward compatibility.  It's ok to
      // not resolve them, even through they're relative URLs, because in a Dart
      // application, "packages/" is managed by pub which creates a symlinked
      // hierarchy and they should all resolve to the same file at any level
      // that a "packages/" exists.
      if (uri.startsWith("/") || uri.startsWith('packages/')) {
        return uri;
      }
    }
    // If it's not absolute, then resolve it first
    Uri resolved = baseUri.resolve(uri);

    // If it's package-relative, tack on 'packages/' - Note that eventually
    // we may want to change this to be '/packages/' to make it truly absolute
    if (resolved.scheme == 'package') {
      return 'packages/${resolved.path}';
    } else if (resolved.isAbsolute && resolved.toString().startsWith(_baseUri)) {
      var path = resolved.path;
      return path.startsWith("/") ? path.substring(1) : path;
    } else {
      return resolved.toString();
    }
  }

  String combineWithType(Type type, String uri) {
    if (_config.useRelativeUrls) {
      return combine(_uriMapper.uriForType(type), uri);
    } else {
      return uri;
    }
  }
}