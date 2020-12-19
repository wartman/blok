package blok.core.foundation.style;

import blok.core.html.Css;
import blok.core.style.StyleExpr;

enum abstract Directionality(String) to String {
  var Rtl = 'rtl';
  var Ltr = 'ltr';
}

enum PseudoType {
  Vendored(s:String);
  Active;
  AnyLink;
  Blank;
  Checked;
  Current;
  Default;
  Defined;
  Dir(d:Directionality);
  Disabled;
  Drop;
  Empty;
  Enabled;
  FirstChild;
  FirstOfType;
  Fullscreen;
  Future;
  Focus;
  FocusVisible;
  FocusWithin;
  Hover;
  Indeterminate;
  InRange;
  Invalid;
  Lang(lang:String);
  LastChild;
  LastOfType;
  Link;
  LocalLink;
  NthChild(factor:Int, offset:Int);
  NthLastChild(factor:Int, offset:Int);
  NthLastOfType(factor:Int, offset:Int);
  NthOfType(factor:Int, offset:Int);
  OnlyChild;
  OnlyOfType;
  Optional;
  OutOfRange;
  Past;
  PlaceholderShown;
  ReadOnly;
  ReadWrite;
  Required;
  Right;
  Root;
  Scope;
  Target;
  TargetWithin;
  UserInvalid;
  Valid;
  Visited;
  GrammarError;
  Marker;
  Placeholder;
  Selection;
  SpellingError;
  After;
  Before;
  Cue;
  FirstLetter;
  FirstLine;
  Has(s:String);
  Is(s:String);
  Not(s:String);
  Where(s:String);
}

class Pseudo {
  public static function wrap(type:PseudoType, exprs:Array<StyleExpr>) {
    return Css.modifier(stringifyType(type), exprs);
  }

  /**
    Define an inline pseudo wrapper.

    Note: Just as with `Style.define`, this style will NOT update
    if values change. Only the initial configuration will
    have an effect. Use with caution.
  **/
  public macro static function define(type, exprs) {
    return macro blok.core.style.Style.define(
      @:pos(type.pos) blok.core.foundation.style.Pseudo.wrap(type, exprs)
    );
  }

  static function stringifyType(type:PseudoType):String {
    return switch type {
      case Vendored(s): s;
      case Dir(s): ':dir($s)';
      case Lang(s): ':name($s)';
      // case NthChild(factor, offset): ':nth-child(${args(factor, offset)})';
      // case NthLastChild(factor, offset): ':nth-last-child(${args(factor, offset)})';
      // case NthLastOfType(factor, offset): ':nth-last-of-type(${args(factor, offset)})';
      // case NthOfType(factor, offset): ':nth-of-type(${args(factor, offset)})';
      case Has(s): ':has(${s})';
      case Is(s): ':is(${s})';
      case Not(s): ':not(${s})';
      case Where(s): ':where(${s})';
      case Active: ':active';
      case AnyLink: ':any-link';
      case Blank: ':blank';
      case Checked: ':checked';
      case Current: ':current';
      case Default: ':default';
      case Defined: ':defined';
      case Disabled: ':disabled';
      case Drop: ':drop';
      case Empty: ':empty';
      case Enabled: ':enabled';
      case FirstChild: ':first-child';
      case FirstOfType: ':first-of-type';
      case Fullscreen: ':fullscreen';
      case Future: ':future';
      case Focus: ':focus';
      case FocusVisible: ':focus-visible';
      case FocusWithin: ':focus-within';
      case Hover: ':hover';
      case Indeterminate: ':indeterminate';
      case InRange: ':in-range';
      case Invalid: ':invalid';
      case LastChild: ':last-child';
      case LastOfType: ':last-of-type';
      case Link: ':link';
      case LocalLink: ':local-link';
      case OnlyChild: ':only-child';
      case OnlyOfType: ':only-of-type';
      case Optional: ':optional';
      case OutOfRange: ':out-of-range';
      case Past: ':past';
      case PlaceholderShown: ':placeholder-shown';
      case ReadOnly: ':read-only';
      case ReadWrite: ':read-write';
      case Required: ':required';
      case Right: ':right';
      case Root: ':root';
      case Scope: ':scope';
      case Target: ':target';
      case TargetWithin: ':target-within';
      case UserInvalid: ':user-invalid';
      case Valid: ':valid';
      case Visited: ':visited';
      case GrammarError: '::grammar-error';
      case Marker: '::marker';
      case Placeholder: '::placeholder';
      case Selection: '::selection';
      case SpellingError: '::spelling-error';
      case After: '::after';
      case Before: '::before';
      case Cue: '::cue';
      case FirstLetter: '::first-letter';
      case FirstLine: '::first-line';
      default:
        throw 'Not Implemented Yet';
    }
  }
}
