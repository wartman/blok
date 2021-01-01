package blok.core.html;

class Xml {
  /**
    Parse XML into Blok VNodes.
  
    Note: this is NOT a fully featured DSL like HXX. It's really only designed
    for things like copying svg or some static HTML. String interpolation WILL
    NOT WORK.
  
    Also note: svg nodes must be prefixed with `svg:` -- for example:
  
    ```xml
      <svg:svg>
        <svg:path d="..." />
        <!-- Note: the prefix is not required if the node is a a child of a `svg:...` node! -->
        <path d="..." />
      </svg:svg>
    ```
  **/
  public static macro function create(e) {
    return blok.core.html.XmlBuilder.parseXml(e);
  }
}
