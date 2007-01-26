<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="#default" xmlns:redirect="http://xml.apache.org/xalan/redirect" extension-element-prefixes="redirect">

  <!--Our output is XHTML, so XML will do...-->
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

  <!--Whether the XML file describing the client libraries exists.-->
  <xsl:param name="client-xml-exists" select="false()"/>


  <!--The output directory for the files generated by this template.-->
  <xsl:param name="output-dir" select="'./'"/>


  <!--Whether this API contains REST endpoints, too.-->
  <xsl:variable name="restful" select="boolean(/api-docs/rest/resources/resource)"/>


  <!--The global side navigation (the navigation that is always there).-->
  <xsl:variable name="global-sidnav">
    <xsl:if test="$client-xml-exists or boolean(/api-docs/@licenseFile)">
      <h1>Downloads</h1>
      <ul>
        <xsl:if test="$client-xml-exists">
          <li>
            <a href="clientlibs.html">client libraries</a>
          </li>
        </xsl:if>
        <xsl:if test="/api-docs/@licenseFile">
          <li>
            <a href="{/api-docs/@licenceFile}">license</a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>

    <h1>SOAP</h1>
    <ul>
      <xsl:for-each select="/api-docs/soap/wsdls/wsdl/endpointInterface">
        <li>
          <xsl:choose>
            <xsl:when test="tag[@name='deprecated']">
              <font style="text-decoration:line-through;">
                <a href="soap_{../@namespaceId}_{@name}.html"><xsl:value-of select="@name"/></a>
              </font>
            </xsl:when>
            <xsl:otherwise>
              <a href="soap_{../@namespaceId}_{@name}.html"><xsl:value-of select="@name"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>

    <xsl:if test="$restful">
      <h1>REST</h1>
      <ul>
        <xsl:for-each select="/api-docs/rest/resources/resource">
          <li><a href="rest_{@name}.html"><xsl:value-of select="@name"/></a></li>
        </xsl:for-each>
      </ul>
    </xsl:if>

    <h1>Data Types</h1>
    <ul>
      <xsl:for-each select="/api-docs/data/schema/types/type">
        <li>
          <xsl:choose>
            <xsl:when test="tag[@name='deprecated']">
              <font style="text-decoration:line-through;">
                Type <a href="data_{../../@namespaceId}.html#{@name}"><xsl:value-of select="@name"/></a>
              </font>
            </xsl:when>
            <xsl:otherwise>
              Type <a href="data_{../../@namespaceId}.html#{@name}"><xsl:value-of select="@name"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:variable>


  <!--The footer for each page.-->
  <xsl:variable name="footer">
    <div class="footer">
      <xsl:if test="/api-docs/@copyright"><xsl:text disable-output-escaping="yes">&#38;</xsl:text>#169; <xsl:value-of select="/api-docs/@copyright"/>.</xsl:if>
      Valid <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a> and <a href="http://validator.w3.org/check?uri=referer">XHTML</a>.
      Generated by <a href="http://enunciate.sourceforge.net">Enunciate</a>. Template design by <a href="http://templates.arcsin.se">Arcsin</a>.
    </div>
  </xsl:variable>


  <!--The main template. Generates the index page and is the invoker for the other templates as necessary.-->
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
        <xsl:for-each select="/api-docs/tag">
          <meta name="{@name}" content="{.}"/>
        </xsl:for-each>
        <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>

        <title>
          <xsl:value-of select="/api-docs/@title"/>
        </title>
      </head>

      <body>
        <div class="container">

          <div class="main">

            <div class="header">
              <div class="title">
                <h1>
                  <xsl:value-of select="/api-docs/@title"/>
                </h1>
              </div>
            </div>

            <div class="content">

              <xsl:if test="/api-docs/documentation">
                <!--Include an introduction if there is top-level documentation.-->
                <div class="item">
                  <h1>Introduction</h1>
                  <p>
                    <xsl:value-of select="/api-docs/documentation" disable-output-escaping="yes"/>
                  </p>
                </div>
              </xsl:if>

              <div class="item">

                <h1>SOAP</h1>

                <p>
                  This API is exposed through a set of <a href="http://www.ws-i.org/Profiles/BasicProfile-1.0.html">WSI Basic Profile</a>
                  -compliant SOAP v1.1 endpoints. The API supports <a href="http://www.w3.org/TR/2005/REC-xop10-20050125/">XML-binary Optimized Pacakging (XOP)</a>
                  and <a href="http://www.w3.org/TR/2004/WD-soap12-mtom-20040608/">SOAP Message Transmission Optimization Mechanism (MTOM)</a>
                  for transmission of binary data. The SOAP API is fully described by the following endpoints:
                </p>

                <xsl:for-each select="/api-docs/soap/wsdls/wsdl">
                  <xsl:variable name="ns" select="@namespace"/>
                  <xsl:variable name="nsid" select="@namespaceId"/>

                  <xsl:choose>
                    <xsl:when test="string-length($ns) = 0">
                      <h1>Default Namespace<xsl:if test="@file"> (<a href="{@file}">wsdl</a>)</xsl:if>:</h1>
                    </xsl:when>
                    <xsl:otherwise>
                      <h1>Namespace <u><xsl:value-of select="@namespace"/></u><xsl:if test="@file"> (<a href="{@file}">wsdl</a>)</xsl:if>:</h1>
                    </xsl:otherwise>
                  </xsl:choose>

                  <ul>
                    <xsl:for-each select="endpointInterface">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              <a href="soap_{$nsid}_{@name}.html"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="soap_{$nsid}_{@name}.html"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                      <xsl:call-template name="soap-endpoint"/>
                    </xsl:for-each>
                  </ul>
                </xsl:for-each>

                <xsl:if test="$client-xml-exists">
                  <p>
                    The SOAP API is also accessible by client-side libraries that can be downloaded from the <a href="clientlibs.html">download page</a>.
                  </p>
                  <xsl:call-template name="clientlibs"/>
                </xsl:if>

              </div>

              <xsl:if test="$restful">
                <div class="item">

                  <h1>REST</h1>

                  <p>
                    This API supports a <a href="http://en.wikipedia.org/wiki/Representational_State_Transfer">Representational State Transfer (REST)</a>
                    model for accessing a set of resources through a fixed set of operations. The following resources are accessible through the RESTful model:
                  </p>

                  <ul>
                    <xsl:for-each select="/api-docs/rest/resources/resource">
                      <li><a href="rest_{@name}.html"><xsl:value-of select="@name"/></a></li>
                      <xsl:call-template name="rest-resource"/>
                    </xsl:for-each>
                  </ul>

                </div>
              </xsl:if>

              <div class="item">

                <h1>Data</h1>

                <p>
                  All SOAP endpoints<xsl:if test="$restful"> and REST operations</xsl:if> act on the same set of data described by
                  <a href="http://www.w3.org/XML/Schema">XML Schema</a>. The following data (grouped by namespace) are available:
                </p>

                <xsl:for-each select="/api-docs/data/schema">
                  <xsl:variable name="ns" select="@namespace"/>
                  <xsl:variable name="nsid" select="@namespaceId"/>

                  <xsl:choose>
                    <xsl:when test="string-length($ns) = 0">
                      <h1>Default Namespace<xsl:if test="@file"> (<a href="{@file}">schema</a>)</xsl:if>:</h1>
                    </xsl:when>
                    <xsl:otherwise>
                      <h1>Namespace <u><xsl:value-of select="@namespace"/></u><xsl:if test="@file"> (<a href="{@file}">schema</a>)</xsl:if>:</h1>
                    </xsl:otherwise>
                  </xsl:choose>

                  <ul>
                    <xsl:for-each select="types/type">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              Type <a href="data_{$nsid}.html#{@name}"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            Type <a href="data_{$nsid}.html#{@name}"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                    <xsl:for-each select="elements/element">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              Element <a href="data_{$nsid}.html#element_{@name}"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            Element <a href="data_{$nsid}.html#element_{@name}"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                  </ul>
                  <xsl:call-template name="data-schema"/>
                </xsl:for-each>
              </div>

            </div>

            <div class="sidenav">
              <xsl:copy-of select="$global-sidnav"/>
            </div>

            <div class="clearer">
              <span></span>
            </div>

          </div>

          <xsl:copy-of select="$footer"/>

        </div>

      </body>

    </html>
  </xsl:template>

  <xsl:template name="soap-endpoint">
    <redirect:write file="{$output-dir}/soap_{../@namespaceId}_{@name}.html">
      <html>

        <head>
          <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
          <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>
          <title>
            <xsl:value-of select="/api-docs/@title"/>
          </title>
        </head>

        <body>

          <div class="container">

            <div class="main">

              <div class="header">
                <div class="title">
                  <h1><xsl:value-of select="/api-docs/@title"/></h1>
                </div>
              </div>

              <div class="content">

                <div class="item">

                  <h1><xsl:value-of select="@name"/></h1>
                  <xsl:choose>
                    <xsl:when test="string-length(../@namespace) = 0">
                      <p class="descr">Default Namespace<xsl:if test="../@file"> (<a href="{../@file}">wsdl</a>)</xsl:if></p>
                    </xsl:when>
                    <xsl:otherwise>
                      <p class="descr">Namespace <u><xsl:value-of select="../@namespace"/></u><xsl:if test="../@file"> (<a href="{../@file}">wsdl</a>)</xsl:if>:</p>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:if test="tag[@name='deprecated']">
                    <p class="deprecated">
                      This endpoint has been deprecated.  <xsl:value-of select="tag[@name='deprecated']" disable-output-escaping="yes"/>
                    </p>
                  </xsl:if>

                  <xsl:if test="documentation">
                    <p>
                      <xsl:value-of select="documentation" disable-output-escaping="yes"/>
                    </p>
                  </xsl:if>

                  <p>
                    The following methods are available on this endpoint:
                  </p>

                  <ul>
                    <xsl:for-each select="method">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              <a href="#{@name}"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="#{@name}"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                  </ul>

                </div>

                <xsl:for-each select="method">
                  <div class="item">

                    <a name="{@name}"></a>
                    <h1><xsl:value-of select="@name"/></h1>

                    <xsl:if test="tag[@name='deprecated']">
                      <p class="deprecated">
                        This method has been deprecated.  <xsl:value-of select="tag[@name='deprecated']" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="documentation">
                      <p>
                        <xsl:value-of select="documentation" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="parameter[@input='true']">
                      <h2>Input Parameters</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <!--todo: add the parameter type and whether its a collection-->
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="parameter[@input='true']">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                    <xsl:if test="parameter[@output='true']">
                      <h2>Output Parameters</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <!--todo: add the parameter type and whether its a collection-->
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="parameter[@output='true']">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                    <xsl:if test="@oneWay='true'">
                      <p>This method is one-way.</p>
                    </xsl:if>

                    <xsl:if test="result">
                      <h2>Return Value</h2>
                      <!--todo: put the return value type.-->

                      <p><xsl:value-of select="result" disable-output-escaping="yes"/></p>
                    </xsl:if>

                    <xsl:if test="fault">
                      <h2>Faults</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="fault">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                  </div>
                </xsl:for-each>
            </div>

          <div class="sidenav">
            <h1><xsl:value-of select="@name"/></h1>
            <ul>
              <xsl:for-each select="method">
                <li>
                  <xsl:choose>
                    <xsl:when test="tag[@name='deprecated']">
                      <font style="text-decoration:line-through;">
                        <a href="#{@name}"><xsl:value-of select="@name"/></a>
                      </font>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="#{@name}"><xsl:value-of select="@name"/></a>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:for-each>
            </ul>

            <xsl:copy-of select="$global-sidnav"/>
          </div>

          <div class="clearer"><span></span></div>

        </div>

        <xsl:copy-of select="$footer"/>

      </div>

      </body>

      </html>
    </redirect:write>
  </xsl:template>

  <xsl:template name="clientlibs">
    <redirect:write file="{$output-dir}/clientlibs.html">
      <xsl:variable name="client-xml" select="document('client-libraries.xml')"/>

      <html>

        <head>
          <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
          <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>
          <title>
            <xsl:value-of select="/api-docs/@title"/>
          </title>
        </head>

        <body>

          <div class="container">

            <div class="main">

              <div class="header">
                <div class="title">
                  <h1><xsl:value-of select="/api-docs/@title"/></h1>
                </div>
              </div>

              <div class="content">
                <div class="item">

                  <h1>Introduction</h1>

                  <xsl:if test="/api-docs/@licenseFile">
                    <p>
                      By downloading these client libraries, you agree to the <a href="{/api-docs/@licenceFile}">license agreement</a>.
                    </p>
                  </xsl:if>

                  <p>
                    The following client libraries are available for download:
                  </p>

                  <ul>
                    <xsl:for-each select="$client-xml/client-libraries/library">
                      <li><a href="#{@name}"><xsl:value-of select="@name"/></a></li>
                    </xsl:for-each>
                  </ul>

                </div>

                <xsl:for-each select="$client-xml/client-libraries/library">
                  <div class="item">

                    <a name="{@name}"></a>
                    <h1><xsl:value-of select="@name"/></h1>

                    <p class="descr">Created <xsl:value-of select="created"/> for <xsl:value-of select="platform"/>.</p>

                    <p>
                      <xsl:value-of select="description" disable-output-escaping="yes"/>
                    </p>

                    <h2>Files</h2>
                    <table>
                      <tr>
                        <th>file</th>
                        <th>description</th>
                      </tr>
                      <xsl:for-each select="files/file">
                        <tr>
                          <td><a href="{@name}"><xsl:value-of select="@name"/></a></td>
                          <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                        </tr>
                      </xsl:for-each>
                    </table>
                  </div>
                </xsl:for-each>

          </div>

          <div class="sidenav">
            <xsl:copy-of select="$global-sidnav"/>
          </div>

          <div class="clearer"><span></span></div>

        </div>

        <xsl:copy-of select="$footer"/>

      </div>

      </body>

      </html>
    </redirect:write>
  </xsl:template>

  <xsl:template name="rest-resource">
    <redirect:write file="{$output-dir}/rest_{@name}.html">
      <html>

        <head>
          <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
          <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>
          <title>
            <xsl:value-of select="/api-docs/@title"/>
          </title>
        </head>

        <body>

          <div class="container">

            <div class="main">

              <div class="header">
                <div class="title">
                  <h1><xsl:value-of select="/api-docs/@title"/></h1>
                </div>
              </div>

              <div class="content">
                <div class="item">

                  <h1><xsl:value-of select="@name"/></h1>

                  <p>
                    The following methods are supported on this resource:
                  </p>

                  <ul>
                    <xsl:for-each select="operation">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              <a href="#{@type}"><xsl:value-of select="@type"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="#{@type}"><xsl:value-of select="@type"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                  </ul>

                </div>

                <xsl:for-each select="operation">
                  <div class="item">

                    <a name="{@type}"></a>
                    <h1><xsl:value-of select="@type"/></h1>

                    <xsl:if test="tag[@name='deprecated']">
                      <p class="deprecated">
                        This method has been deprecated.  <xsl:value-of select="tag[@name='deprecated']" disable-output-escaping="yes"/>.
                      </p>
                    </xsl:if>

                    <xsl:if test="@requiresResourceId='true'">
                      <p>
                        This method requires a resource id on the URL (e.g. "<xsl:value-of select="translate(@type,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> <xsl:value-of select="concat('/context/', ../@name, '/[id-goes-here]')"/>").
                      </p>
                    </xsl:if>

                    <xsl:if test="documentation">
                      <p>
                        <xsl:value-of select="documentation" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="parameter">
                      <h2>Possible HTTP Parameters</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <!--todo: put the type of the parameter.-->
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="parameter">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                    <xsl:if test="inValue">
                      <h2>Input Payload</h2>
                      <!--todo: put the type of the payload.-->
                      
                      <p>
                        <xsl:value-of select="inValue" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="outValue">
                      <h2>Output Payload</h2>
                      <!--todo: put the type of the payload.-->

                      <p>
                        <xsl:value-of select="outValue" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="error">
                      <h2>Errors</h2>
                      <table>
                        <tr>
                          <th>code</th>
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="error">
                          <tr>
                            <td><xsl:value-of select="@code"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                  </div>
                </xsl:for-each>
              </div>

          <div class="sidenav">
            <h1><xsl:value-of select="@name"/></h1>

            <ul>
              <xsl:for-each select="operation">
                <li>
                  <xsl:choose>
                    <xsl:when test="tag[@name='deprecated']">
                      <font style="text-decoration:line-through;">
                        <a href="#{@type}"><xsl:value-of select="@type"/></a>
                      </font>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="#{@type}"><xsl:value-of select="@type"/></a>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:for-each>
            </ul>

            <xsl:copy-of select="$global-sidnav"/>
          </div>

          <div class="clearer"><span></span></div>

        </div>

        <xsl:copy-of select="$footer"/>

      </div>

      </body>

      </html>
    </redirect:write>
  </xsl:template>

  <xsl:template name="data-schema">
    <redirect:write file="{$output-dir}/data_{@namespaceId}.html">
      <html>

        <head>
          <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
          <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>
          <title>
            <xsl:value-of select="/api-docs/@title"/>
          </title>
        </head>

        <body>

          <div class="container">

            <div class="main">

              <div class="header">
                <div class="title">
                  <h1><xsl:value-of select="/api-docs/@title"/></h1>
                </div>
              </div>

              <div class="content">
                <div class="item">

                  <xsl:choose>
                    <xsl:when test="string-length(@namespace) = 0">
                      <h1>Default Namespace</h1>
                    </xsl:when>
                    <xsl:otherwise>
                      <h1>Namespace <u><xsl:value-of select="@namespace"/></u></h1>
                    </xsl:otherwise>
                  </xsl:choose>

                  <p>
                    The following types are members of this namespace:
                  </p>

                  <ul>
                    <xsl:for-each select="types/type">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              <a href="#{@name}"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="#{@name}"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                  </ul>

                  <p>
                    The following elements are members of this namespace:
                  </p>

                  <ul>
                    <xsl:for-each select="elements/element">
                      <li>
                        <xsl:choose>
                          <xsl:when test="tag[@name='deprecated']">
                            <font style="text-decoration:line-through;">
                              <a href="#element_{@name}"><xsl:value-of select="@name"/></a>
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="#element_{@name}"><xsl:value-of select="@name"/></a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </xsl:for-each>
                  </ul>

                </div>

                <xsl:for-each select="types/type">
                  <div class="item">

                    <a name="{@name}"></a>
                    <h1><xsl:value-of select="@name"/></h1>
                    <xsl:if test="@extendsType">
                      <xsl:variable name="typeId" select="@extendsType"/>
                      <xsl:variable name="extendedType" select="//type[@id=$typeId]"/>
                      <p class="descr">extends <a href="data_{$extendedType/../../@namespaceId}.html#{$extendedType/@name}"><xsl:value-of select="$extendedType/@name"/></a></p>
                    </xsl:if>

                    <xsl:if test="tag[@name='deprecated']">
                      <p class="deprecated">
                        This type has been deprecated.  <xsl:value-of select="tag[@name='deprecated']" disable-output-escaping="yes"/>.
                      </p>
                    </xsl:if>

                    <xsl:if test="documentation">
                      <p>
                        <xsl:value-of select="documentation" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                    <xsl:if test="attributes">
                      <h2>Attributes</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <!--todo: do the type-->
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="attributes/attribute">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                    <xsl:if test="elements">
                      <h2>Child Elements</h2>
                      <table>
                        <tr>
                          <th>name</th>
                          <!--todo: do the type-->
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="elements/element">
                          <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="." disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>

                    <xsl:if test="value">
                      <h2>Value</h2>
                      <!--todo: do the type of the value.-->

                      <p><xsl:value-of select="value" disable-output-escaping="yes"/></p>
                    </xsl:if>

                    <xsl:if test="values">
                      <h2>Possible Values</h2>
                      <table>
                        <tr>
                          <th>value</th>
                          <th>description</th>
                        </tr>
                        <xsl:for-each select="values/item">
                          <tr>
                            <xsl:choose>
                              <xsl:when test="tag[@name='deprecated']">
                                <td><font style="text-decoration:line-through;"><xsl:value-of select="@value"/></font></td>
                              </xsl:when>
                              <xsl:otherwise>
                                <td><xsl:value-of select="@value"/></td>
                              </xsl:otherwise>
                            </xsl:choose>
                            <td><xsl:value-of select="documentation" disable-output-escaping="yes"/></td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:if>
                    
                  </div>
                </xsl:for-each>

                <xsl:for-each select="elements/element">
                  <div class="item">

                    <a name="element_{@name}"></a>
                    <h1><xsl:value-of select="@name"/></h1>
                    <xsl:variable name="typeId" select="@type"/>
                    <xsl:variable name="elType" select="//type[@id=$typeId]"/>
                    <p class="descr">type: <a href="data_{$elType/../../@namespaceId}.html#{$elType/@name}"><xsl:value-of select="$elType/@name"/></a></p>

                    <xsl:if test="tag[@name='deprecated']">
                      <p class="deprecated">
                        This element has been deprecated.  <xsl:value-of select="tag[@name='deprecated']" disable-output-escaping="yes"/>.
                      </p>
                    </xsl:if>

                    <xsl:if test="documentation">
                      <p>
                        <xsl:value-of select="documentation" disable-output-escaping="yes"/>
                      </p>
                    </xsl:if>

                  </div>
                </xsl:for-each>
              </div>

          <div class="sidenav">
            <xsl:copy-of select="$global-sidnav"/>
          </div>

          <div class="clearer"><span></span></div>

        </div>

        <xsl:copy-of select="$footer"/>

      </div>

      </body>

      </html>
    </redirect:write>
  </xsl:template>

</xsl:stylesheet>