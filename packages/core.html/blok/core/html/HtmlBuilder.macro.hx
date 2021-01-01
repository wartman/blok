package blok.core.html;

import haxe.macro.Type;
import haxe.macro.Context;

using haxe.macro.Tools;

enum abstract TagKind(String) to String {
  var TagVoid = 'void';
  var TagNormal = 'normal';
  var TagOpaque = 'opaque';
}

typedef TagInfo = {
  name:String,
  kind:TagKind,
  type:Type  
}

class HtmlBuilder {
  public static function build(tagPath:String, ?prefix:String) {
    var fields = Context.getBuildFields();
    var tags = getTags(tagPath);

    for (tag in tags) switch tag.kind {
      case TagNormal:
        var name = tag.name;
        var type = tag.type.toComplexType();
        fields = fields.concat((macro class {
          
          public static inline function $name(
            props:blok.core.html.Html.HtmlChildrenProps<$type & blok.core.html.HtmlEvents>
          ):VNode<Node> {
            return VNative(
              blok.NodeType.get($v{prefix != null ? '$prefix:${tag.name}' : name}),
              if (props.attrs != null) props.attrs else {},
              props.ref,
              props.key,
              props.children
            );
          }

        }).fields);
      default:
        var name = tag.name;
        var type = tag.type.toComplexType();
        fields = fields.concat((macro class {
          
          public static inline function $name(
            props:blok.core.html.Html.HtmlBaseProps<$type & blok.core.html.HtmlEvents>
          ):VNode<Node> {
            return VNative(
              blok.NodeType.get($v{prefix != null ? '$prefix:${tag.name}' : name}),
              if (props.attrs != null) props.attrs else {},
              props.ref,
              props.key,
              []
            );
          }

        }).fields);
    }

    return fields;
  }

  static function getTags(tagPath:String):Array<TagInfo> {
    var tags:Array<TagInfo> = [];
    var t = Context.getType(tagPath);
    var groups = switch t {
      case TType(t, params): switch (t.get().type) {
        case TAnonymous(a): a.get().fields;
        default: throw 'assert';
      }
      default:
        throw 'assert';
    }

    for (group in groups) {
      var kind:TagKind = cast group.name;
      var fields = switch group.type {
        case TAnonymous(a): a.get().fields;
        default: throw 'assert';
      }
      for (f in fields) {
        tags.push({
          name: f.name,
          type: f.type,
          kind: kind
        });
      }
    }

    return tags;
  }
}