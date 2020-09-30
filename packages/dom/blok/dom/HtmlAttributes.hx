package blok.dom;

// @todo: @:html(...) and @:jsOnly currently have no effect.

// From https://github.com/haxetink/tink_domspec/blob/master/src/tink/domspec/Attributes.hx
typedef GlobalAttr = {
  @:html('class') @:optional final className:String;
  @:optional final id:String;
  @:optional final title:String;
  @:optional final lang:String;
  @:optional final dir:String;
  @:optional final contentEditable:Bool;
  @:optional final inputmode:Bool;

  @:optional final hidden:Bool;
  @:optional final tabIndex:Int;
  @:optional final accessKey:String;
  @:optional final draggable:Bool;
  @:optional final spellcheck:Bool;
  @:optional final style:String;
  @:optional final role:String;
}

typedef DetailsAttr = GlobalAttr & {
  @:optional final open:Bool;
}

typedef FieldSetAttr = GlobalAttr & {
  @:optional final disabled:Bool;
  @:optional final name:String;
}

typedef ObjectAttr = GlobalAttr & {
  @:optional final type:String;
  @:optional final data:String;
  @:optional final width:Int;
  @:optional final height:Int;
}

typedef ParamAttr = GlobalAttr & {
  final name:String;
  final value:String;
}


typedef TableCellAttr = GlobalAttr & {
  @:optional final abbr:String;
  @:optional final colSpan:Int;
  @:optional final headers:String;
  @:optional final rowSpan:Int;
  @:optional final scope:String;
  @:optional final sorted:String;
}

enum abstract InputType(String) to String {
  var Text = 'text';
  var Button = 'button';
  var Checkbox = 'checkbox';
  var Color = 'color';
  var Date = 'date';
  var DatetimeLocal = 'datetime-local';
  var Email = 'email';
  var File = 'file';
  var Hidden = 'hidden';
  var Image = 'image';
  var Month = 'month';
  var Number = 'number';
  var Password = 'password';
  var Radio = 'radio';
  var Range = 'range';
  var Reset = 'reset';
  var Search = 'search';
  var Tel = 'tel';
  var Submit = 'submit';
  var Time = 'time';
  var Url = 'url';
  var Week = 'week';
}

typedef InputAttr = GlobalAttr & {
  @:optional final checked:Bool;
  @:optional final disabled:Bool;
  @:optional final required:Bool;
  @:optional final autofocus:Bool;
  @:optional final autocomplete:String;
  @:optional final value:String;
  @:optional final readOnly:Bool;
  @:html('value') @:optional final defaultValue:String;
  @:optional final type:InputType;
  @:optional final name:String;
  @:optional final placeholder:String;
  @:optional final max:String;
  @:optional final min:String;
  @:optional final step:String;
  @:optional final maxLength:Int;
  @:optional final pattern:String;
  @:optional final accept:String;
  @:optional final multiple:Bool;
}

typedef ButtonAttr = GlobalAttr & {
  @:optional final disabled:Bool;
  @:optional final autofocus:Bool;
  @:optional final type:String;
  @:optional final name:String;
}

typedef TextAreaAttr = GlobalAttr & {
  @:optional final autofocus:Bool;
  @:optional final cols:Int;
  @:optional final dirname:String;
  @:optional final disabled:Bool;
  @:optional final form:String;
  @:optional final maxlength:Int;
  @:optional final name:String;
  @:optional final placeholder:String;
  @:optional final readOnly:Bool;
  @:optional final required:Bool;
  @:optional final rows:Int;
  @:optional final value:String;
  @:optional final defaultValue:String;
  @:optional final wrap:String;
}

typedef IFrameAttr = GlobalAttr & {
  @:optional final sandbox:String;
  @:optional final width:Int;
  @:optional final height:Int;
  @:optional final src:String;
  @:optional final srcdoc:String;
  @:optional final allowFullscreen:Bool;
  @:deprecated @:optional final scrolling:IframeScrolling;
}

enum abstract IframeScrolling(String) {
  var Yes = "yes";
  var No = "no";
  var Auto = "auto";
}

typedef ImageAttr = GlobalAttr & {
  @:optional final src:String;
  @:optional final width:Int;
  @:optional final height:Int;
  @:optional final alt:String;
  @:optional final srcset:String;
  @:optional final sizes:String;
}

private typedef MediaAttr = GlobalAttr & {
  @:optional final src:String;
  @:optional final autoplay:Bool;
  @:optional final controls:Bool;
  @:optional final loop:Bool;
  @:optional final muted:Bool;
  @:optional final preload:String;
  @:optional final volume:Float;
}

typedef AudioAttr = MediaAttr & {};

typedef VideoAttr = MediaAttr & {
  @:optional final height:Int;
  @:optional final poster:String;
  @:optional final width:Int;
  @:optional final playsInline:Bool;
}

typedef SourceAttr = GlobalAttr & {
  @:optional final src:String;
  @:optional final srcset:String;
  @:optional final media:String;
  @:optional final sizes:String;
  @:optional final type:String;
}

typedef LabelAttr = GlobalAttr & {
  @:html('for') @:optional final htmlFor:String;
}

typedef SelectAttr = GlobalAttr & {
  @:optional final autofocus:Bool;
  @:optional final disabled:Bool;
  @:optional final multiple:Bool;
  @:optional final name:String;
  @:optional final required:Bool;
  @:optional final size:Int;
}

typedef FormAttr = GlobalAttr & {
  @:optional final method:String;
  @:optional final action:String;
}

typedef AnchorAttr = GlobalAttr & {
  @:optional final href:String;
  @:optional final target:String;
  @:optional final type:String;
  @:optional final rel:AnchorRel;
}

typedef OptionAttr = GlobalAttr & {
  @:optional var disabled:Bool;
  @:optional final label:String;
  @:jsOnly @:optional final defaultSelected:Bool;
  @:optional final selected:Bool;
  @:optional final value:String;
  @:optional final text:String;
  @:optional final index:Int;
}

typedef MetaAttr = GlobalAttr & {
  @:optional final content:String;
  @:optional final name:String;
  @:optional final charset:String;
  @:optional final httpEquiv:MetaHttpEquiv;
}

enum abstract MetaHttpEquiv(String) to String from String {
  var ContentType = "content-type";
  var DefaultStyle = "default-style";
  var Refresh = "refresh";
}

typedef LinkAttr = GlobalAttr & {
  final rel:LinkRel;
  @:optional final crossorigin:LinkCrossOrigin;
  @:optional final href:String;
  @:optional final hreflang:String;
  @:optional final media:String;
  @:optional final sizes:String;
  @:optional final type:String;
}

enum abstract LinkRel(String) to String from String {
  var Alternate = "alternate";
  var Author = "author";
  var DnsPrefetch = "dns-prefetch";
  var Help = "help";
  var Icon = "icon";
  var License = "license";
  var Next = "next";
  var Pingback = "pingback";
  var Preconnect = "preconnect";
  var Prefetch = "prefetch";
  var Preload = "preload";
  var Prerender = "prerender";
  var Prev = "prev";
  var Search = "search";
  var Stylesheet = "stylesheet";
}

enum abstract AnchorRel(String) to String from String {
  var Alternate = "alternate";
  var Author = "author";
  var Bookmark = "bookmark";
  var External = "external";
  var Help = "help";
  var License = "license";
  var Next = "next";
  var NoFollow = "nofollow";
  var NoReferrer = "noreferrer";
  var NoOpener = "noopener";
  var Prev = "prev";
  var Search = "search";
  var Tag = "tag";
}

enum abstract LinkCrossOrigin(String) to String from String {
  var Anonymous = "anonymous";
  var UseCredentials = "use-credentials";
}

typedef ScriptAttr = GlobalAttr & {
  @:optional final async:Bool;
  @:optional final charset:String;
  @:optional final defer:Bool;
  @:optional final src:String;
  @:optional final type:String;
}

typedef StyleAttr = GlobalAttr & {
  @:optional final type:String;
  @:optional final media:String;
  @:optional final nonce:String;
}

typedef CanvasAttr = GlobalAttr & {
  @:optional final width:String;
  @:optional final height:String;
}

typedef TrackAttr = {
  final src:String;
  @:optional final kind:TrackKind;
  @:optional final label:String;
  @:optional final srclang:String;
}

enum abstract TrackKind(String) to String from String {
  var Subtitles = 'subtitles';
  var Captions = 'captions';
  var Descriptions = 'descriptions';
  var Chapters = 'chapters';
  var Metadata = 'metadata';
}

typedef EmbedAttr = {
  final height:Int;
  final width:Int;
  final src:String;
  final typed:String;
}

// svg attr reference: https://github.com/dumistoklus/svg-xsd-schema/blob/master/svg.xsd
typedef SvgAttr = GlobalAttr & {
  @:optional final width:String;
  @:optional final height:String;
  @:optional final viewBox:String;// TODO: consider validating constant strings via typedef with @:fromHxx
  @:optional final xmlns:String;// has no effect, but since most svgs come with this set, better to support it I guess
}

// typedef PathAttr = {
//   > GlobalAttr<SvgStyle>,
//   > tink.svgspec.Attributes.PathAttr,
// }
// typedef PolygonAttr = {
//   > GlobalAttr<SvgStyle>,
//   > tink.svgspec.Attributes.PolygonAttr,
// }

// typedef RectAttr = {
//   > GlobalAttr<SvgStyle>,
//   > tink.svgspec.Attributes.RectAttr,
// }
// typedef CircleAttr = {
//   > GlobalAttr<SvgStyle>,
//   > tink.svgspec.Attributes.CircleAttr,
// }
// typedef EllipseAttr = {
//   > GlobalAttr<SvgStyle>,
//   > tink.svgspec.Attributes.EllipseAttr,
// }
