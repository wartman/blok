package features;

using Blok;

class SvgExample extends Component {
  override function render(context:Context) {
    return Html.div({
      children: [
        Svg.svg({
          children: [
            Svg.g({
              attrs: {
                transform: 'translate(-562.58 -31.105)'
              },
              children: [
                Svg.path({
                  attrs: {
                    d: 'm574.4 35.97 8.6348 10.137-8.6348 10.135-2.2832-1.9453 6.9766-8.1895-6.9766-8.1914 2.2832-1.9453z'
                  }
                })
              ]
            })
          ]
        }),

        // Note: you'll probably want to copy and paste when using SVG,
        // which can be done with Blok's XML macro: 
        blok.core.html.Xml.create('
          <svg:svg>
            <g transform="translate(-562.58 -31.105)">
              <path d="m574.4 35.97 8.6348 10.137-8.6348 10.135-2.2832-1.9453 6.9766-8.1895-6.9766-8.1914 2.2832-1.9453z" />
            </g>
          </svg:svg>
        ')
        // Do note that this is not a full DSL, and is really only
        // designed for this limited use case. Error handling is very
        // poor and you cannot use interpolation or arbitratry values.
      ]
    });
  }
}
