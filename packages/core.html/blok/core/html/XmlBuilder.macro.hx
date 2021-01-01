package blok.core.html;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.xml.Parser.XmlParserException;
import Xml;

using haxe.macro.PositionTools;
using StringTools;

class XmlBuilder {
  public static function parseXmlExpr(e:Expr):Expr {
    var posInfos = e.pos.getInfos();
    return switch e.expr {
      case EConst(CString(s, _)):
        try {
          parseXml(s, e.pos);
        } catch (err:XmlParserException) {
          var errPos = Context.makePosition({
            min: posInfos.min + err.position,
            max: posInfos.max,
            file: posInfos.file
          });
          Context.error(err.message, errPos);
          null;
        }
      default:
        Context.error('Expected a string', e.pos);
        macro null;
    }
  }

  public static function parseXml(s:String, pos:Position) {
    var xml = Xml.parse(s.trim());

    function generate(xml:Xml, isSvg:Bool = false):Array<Expr> {
      return [ for (node in xml) switch node.nodeType {
        case Element:
          var name = switch node.nodeName.split(':') {
            case ['svg', name]: 
              isSvg = true;
              name;
            default: 
              node.nodeName;
          };
          var attrs:Array<ObjectField> = [ for (attr in node.attributes()) {
            field: attr,
            expr: macro $v{node.get(attr)}
          } ];
          var children = generate(node, isSvg);
          
          if (isSvg) {
            macro blok.core.html.Svg.$name({
              attrs: ${ {
                expr: EObjectDecl(attrs),
                pos: pos
              } },
              children: [ $a{children} ]
            });
          } else switch generate(node, false) {
            case children if (children.length > 0):
              macro blok.core.html.Html.$name({
                attrs: ${ {
                  expr: EObjectDecl(attrs),
                  pos: pos
                } },
                children: [ $a{children} ]
              });
            default:
              macro blok.core.html.Html.$name({
                attrs: ${ {
                  expr: EObjectDecl(attrs),
                  pos: pos
                } }
              });
          }

        case PCData if (!isSvg):
          var text = node.nodeValue;
          macro blok.core.html.Html.text($v{text});
          
        default: null;
      } ].filter(n -> n != null);
    }

    var vnodes = generate(xml);
    return if (vnodes.length == 1) vnodes[0] else macro blok.core.VNode.VFragment([ $a{vnodes} ]);
  }
}
