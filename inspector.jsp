```jsp
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>


<%
    // ============================================================
    // 1. APPLICATION STARTUP / INITIALIZATION INFORMATION
    // ============================================================

    Long applicationStartTime =
            (Long) application.getAttribute("applicationStartTime");

    if (applicationStartTime == null) {
        applicationStartTime = System.currentTimeMillis();

        application.setAttribute(
                "applicationStartTime",
                applicationStartTime
        );
    }


    // ============================================================
    // 2. JVM MEMORY INFORMATION
    // ============================================================

    Runtime runtime = Runtime.getRuntime();

    long totalMemory = runtime.totalMemory();
    long freeMemory = runtime.freeMemory();
    long usedMemory = totalMemory - freeMemory;
    long maxMemory = runtime.maxMemory();

    long totalMB = totalMemory / (1024 * 1024);
    long freeMB = freeMemory / (1024 * 1024);
    long usedMB = usedMemory / (1024 * 1024);
    long maxMB = maxMemory / (1024 * 1024);


    // ============================================================
    // 3. REQUEST INFORMATION
    // ============================================================

    String requestMethod = request.getMethod();

    String requestURI = request.getRequestURI();

    String requestURL = request.getRequestURL().toString();

    String protocol = request.getProtocol();

    String clientIP = request.getRemoteAddr();

    String remoteHost = request.getRemoteHost();

    String serverName = request.getServerName();

    int serverPort = request.getServerPort();

    String queryString = request.getQueryString();


    // ============================================================
    // 4. RESPONSE INFORMATION
    // ============================================================

    String contentType = response.getContentType();

    String characterEncoding =
            response.getCharacterEncoding();

    int bufferSize =
            response.getBufferSize();


    // ============================================================
    // 5. CONFIG INFORMATION
    // ============================================================

    String servletName =
            config.getServletName();


    // ============================================================
    // 6. PAGECONTEXT INFORMATION
    // ============================================================

    String serverInfo =
            pageContext
                    .getServletContext()
                    .getServerInfo();

    String contextPath =
            pageContext
                    .getServletContext()
                    .getContextPath();


    // ============================================================
    // 7. SESSION INFORMATION
    // ============================================================

    String sessionID =
            session.getId();

    Date sessionCreation =
            new Date(session.getCreationTime());

    Date sessionLastAccess =
            new Date(session.getLastAccessedTime());

    int sessionTimeout =
            session.getMaxInactiveInterval();


    // ============================================================
    // 8. JSP PAGE INFORMATION
    // ============================================================

    String jspPageName =
            request.getServletPath();

    String currentTime =
            new Date().toString();

%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        JSP Anatomy & Lifecycle Inspector
    </title>


    <style>

        /* ======================================================
           GENERAL PAGE STYLE
           ====================================================== */

        * {
            box-sizing: border-box;
        }


        body {

            margin: 0;

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background: #eef2f7;

            color: #1e293b;

        }


        /* ======================================================
           HEADER
           ====================================================== */

        header {

            background:
                linear-gradient(
                    135deg,
                    #172554,
                    #2563eb
                );

            color: white;

            padding: 35px 20px;

            text-align: center;

        }


        header h1 {

            margin: 0;

            font-size: 32px;

        }


        header p {

            margin-top: 10px;

            font-size: 16px;

            opacity: 0.9;

        }


        /* ======================================================
           MAIN CONTAINER
           ====================================================== */

        .container {

            width: 92%;

            max-width: 1250px;

            margin: 30px auto;

        }


        /* ======================================================
           REFRESH AREA
           ====================================================== */

        .refresh-area {

            text-align: center;

            margin-bottom: 25px;

        }


        .refresh-button {

            background: #2563eb;

            color: white;

            border: none;

            padding: 13px 25px;

            border-radius: 8px;

            font-size: 16px;

            cursor: pointer;

            transition: 0.3s;

        }


        .refresh-button:hover {

            background: #1d4ed8;

            transform: scale(1.03);

        }


        /* ======================================================
           DASHBOARD GRID
           ====================================================== */

        .dashboard {

            display: grid;

            grid-template-columns:
                repeat(
                    auto-fit,
                    minmax(330px, 1fr)
                );

            gap: 22px;

        }


        /* ======================================================
           CARDS
           ====================================================== */

        .card {

            background: white;

            border-radius: 14px;

            padding: 22px;

            box-shadow:
                0 5px 18px
                rgba(0, 0, 0, 0.08);

        }


        .card h2 {

            margin-top: 0;

            padding-bottom: 12px;

            border-bottom:
                2px solid #e2e8f0;

            color: #1e3a8a;

            font-size: 21px;

        }


        /* ======================================================
           INFORMATION ROW
           ====================================================== */

        .info-row {

            display: flex;

            justify-content:
                space-between;

            gap: 15px;

            padding: 10px 0;

            border-bottom:
                1px solid #e5e7eb;

        }


        .info-row:last-child {

            border-bottom: none;

        }


        .label {

            font-weight: bold;

            color: #475569;

        }


        .value {

            text-align: right;

            color: #0f172a;

            max-width: 62%;

            word-break: break-word;

        }


        /* ======================================================
           STATUS
           ====================================================== */

        .status {

            display: inline-block;

            padding: 5px 10px;

            border-radius: 20px;

            background: #dcfce7;

            color: #166534;

            font-size: 13px;

            font-weight: bold;

        }


        /* ======================================================
           REQUEST HEADERS
           ====================================================== */

        .headers {

            max-height: 300px;

            overflow-y: auto;

        }


        .header-row {

            padding: 9px;

            margin-bottom: 6px;

            background: #f8fafc;

            border-radius: 6px;

            word-break: break-word;

        }


        .header-name {

            font-weight: bold;

            color: #1d4ed8;

        }


        /* ======================================================
           SESSION ATTRIBUTES
           ====================================================== */

        .session-attributes {

            max-height: 250px;

            overflow-y: auto;

        }


        .attribute-row {

            padding: 9px;

            margin-bottom: 6px;

            background: #f8fafc;

            border-radius: 6px;

        }


        /* ======================================================
           LIFECYCLE
           ====================================================== */

        .lifecycle {

            display: flex;

            flex-direction: column;

            gap: 10px;

        }


        .lifecycle-step {

            padding: 12px;

            background: #f8fafc;

            border-left:
                4px solid #2563eb;

            border-radius: 5px;

        }


        .lifecycle-number {

            font-weight: bold;

            color: #1d4ed8;

        }


        /* ======================================================
           IMPLICIT OBJECT TABLE
           ====================================================== */

        .object-table {

            width: 100%;

            border-collapse:
                collapse;

        }


        .object-table th,
        .object-table td {

            padding: 10px;

            border-bottom:
                1px solid #e2e8f0;

            text-align: left;

        }


        .object-table th {

            background: #f8fafc;

        }


        /* ======================================================
           FULL WIDTH CARD
           ====================================================== */

        .full-width {

            grid-column:
                1 / -1;

        }


        /* ======================================================
           FOOTER
           ====================================================== */

        footer {

            margin-top: 35px;

            padding: 25px;

            text-align: center;

            background: #172554;

            color: white;

        }


        /* ======================================================
           RESPONSIVE DESIGN
           ====================================================== */

        @media (max-width: 600px) {

            header h1 {

                font-size: 24px;

            }


            .info-row {

                flex-direction:
                    column;

            }


            .value {

                text-align: left;

                max-width: 100%;

            }

        }

    </style>

</head>


<body>


<!-- ============================================================
     HEADER
     ============================================================ -->

<header>

    <h1>
        JSP Anatomy & Lifecycle Inspector
    </h1>

    <p>
        Interactive JSP Server Monitoring Dashboard
    </p>

</header>



<div class="container">


    <!-- ========================================================
         REFRESH BUTTON
         ======================================================== -->

    <div class="refresh-area">

        <button
            class="refresh-button"
            onclick="location.reload()">

            🔄 Refresh Dashboard

        </button>

        <p>
            Last Request Time:
            <strong>
                <%= currentTime %>
            </strong>
        </p>

    </div>



    <div class="dashboard">


        <!-- ====================================================
             SERVER INFORMATION
             ==================================================== -->

        <div class="card">

            <h2>
                🖥 Server Information
            </h2>


            <div class="info-row">

                <span class="label">
                    Server
                </span>

                <span class="value">
                    <%= serverInfo %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Server Name
                </span>

                <span class="value">
                    <%= serverName %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Server Port
                </span>

                <span class="value">
                    <%= serverPort %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Context Path
                </span>

                <span class="value">
                    <%= contextPath %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Application Start
                </span>

                <span class="value">
                    <%= new Date(applicationStartTime) %>
                </span>

            </div>

        </div>



        <!-- ====================================================
             REQUEST INFORMATION
             ==================================================== -->

        <div class="card">

            <h2>
                📡 Request Information
            </h2>


            <div class="info-row">

                <span class="label">
                    HTTP Method
                </span>

                <span class="value">
                    <%= requestMethod %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Request URI
                </span>

                <span class="value">
                    <%= requestURI %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Request URL
                </span>

                <span class="value">
                    <%= requestURL %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Protocol
                </span>

                <span class="value">
                    <%= protocol %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Client IP
                </span>

                <span class="value">
                    <%= clientIP %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Remote Host
                </span>

                <span class="value">
                    <%= remoteHost %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Query String
                </span>

                <span class="value">

                    <%= queryString != null
                        ? queryString
                        : "None" %>

                </span>

            </div>

        </div>



        <!-- ====================================================
             JVM MEMORY
             ==================================================== -->

        <div class="card">

            <h2>
                🧠 JVM Memory Usage
            </h2>


            <div class="info-row">

                <span class="label">
                    Used Memory
                </span>

                <span class="value">
                    <%= usedMB %> MB
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Free Memory
                </span>

                <span class="value">
                    <%= freeMB %> MB
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Allocated Memory
                </span>

                <span class="value">
                    <%= totalMB %> MB
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Maximum Memory
                </span>

                <span class="value">
                    <%= maxMB %> MB
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    JVM Status
                </span>

                <span class="value">

                    <span class="status">
                        RUNNING
                    </span>

                </span>

            </div>

        </div>



        <!-- ====================================================
             SESSION INFORMATION
             ==================================================== -->

        <div class="card">

            <h2>
                🔐 Session Information
            </h2>


            <div class="info-row">

                <span class="label">
                    Session ID
                </span>

                <span class="value">
                    <%= sessionID %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Created
                </span>

                <span class="value">
                    <%= sessionCreation %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Last Accessed
                </span>

                <span class="value">
                    <%= sessionLastAccess %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Timeout
                </span>

                <span class="value">
                    <%= sessionTimeout %> seconds
                </span>

            </div>

        </div>



        <!-- ====================================================
             JSP CONFIG INFORMATION
             ==================================================== -->

        <div class="card">

            <h2>
                ⚙ JSP Config
            </h2>


            <div class="info-row">

                <span class="label">
                    Servlet Name
                </span>

                <span class="value">
                    <%= servletName %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    JSP Page
                </span>

                <span class="value">
                    <%= jspPageName %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Config Object
                </span>

                <span class="value">

                    <span class="status">
                        AVAILABLE
                    </span>

                </span>

            </div>

        </div>



        <!-- ====================================================
             RESPONSE INFORMATION
             ==================================================== -->

        <div class="card">

            <h2>
                📤 Response Information
            </h2>


            <div class="info-row">

                <span class="label">
                    Content Type
                </span>

                <span class="value">
                    <%= contentType %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Character Encoding
                </span>

                <span class="value">
                    <%= characterEncoding %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Buffer Size
                </span>

                <span class="value">
                    <%= bufferSize %> bytes
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Response Object
                </span>

                <span class="value">

                    <span class="status">
                        AVAILABLE
                    </span>

                </span>

            </div>

        </div>



        <!-- ====================================================
             JSP IMPLICIT OBJECTS
             ==================================================== -->

        <div class="card full-width">

            <h2>
                🔧 JSP Implicit Objects
            </h2>


            <table class="object-table">

                <tr>

                    <th>
                        Object
                    </th>

                    <th>
                        Purpose
                    </th>

                    <th>
                        Status
                    </th>

                </tr>


                <tr>

                    <td>
                        request
                    </td>

                    <td>
                        Provides information about
                        the client's HTTP request.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        response
                    </td>

                    <td>
                        Represents the HTTP response
                        sent to the client.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        session
                    </td>

                    <td>
                        Maintains information about
                        the current user session.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        application
                    </td>

                    <td>
                        Represents the complete
                        web application.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        config
                    </td>

                    <td>
                        Provides servlet/JSP
                        configuration information.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        pageContext
                    </td>

                    <td>
                        Provides access to the
                        JSP page environment.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        out
                    </td>

                    <td>
                        Writes output to the
                        HTTP response.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        page
                    </td>

                    <td>
                        Represents the current
                        JSP servlet instance.
                    </td>

                    <td>
                        <span class="status">
                            AVAILABLE
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        exception
                    </td>

                    <td>
                        Used for exception information
                        on error pages.
                    </td>

                    <td>
                        Not used on normal page
                    </td>

                </tr>

            </table>

        </div>



        <!-- ====================================================
             REQUEST HEADERS
             ==================================================== -->

        <div class="card full-width">

            <h2>
                📋 HTTP Request Headers
            </h2>


            <div class="headers">

                <%

                    Enumeration<String> headerNames =
                            request.getHeaderNames();


                    if (headerNames != null) {

                        while (
                            headerNames.hasMoreElements()
                        ) {

                            String headerName =
                                    headerNames.nextElement();

                            String headerValue =
                                    request.getHeader(headerName);

                %>

                    <div class="header-row">

                        <span class="header-name">
                            <%= headerName %>
                        </span>

                        :

                        <%= headerValue %>

                    </div>

                <%

                        }

                    }

                %>

            </div>

        </div>



        <!-- ====================================================
             SESSION ATTRIBUTES
             ==================================================== -->

        <div class="card">

            <h2>
                👤 Current Session Parameters
            </h2>


            <div class="session-attributes">

                <%

                    Enumeration<String> sessionAttributes =
                            session.getAttributeNames();


                    if (!sessionAttributes.hasMoreElements()) {

                %>

                    <div class="attribute-row">

                        No session attributes currently stored.

                    </div>

                <%

                    }


                    while (
                        sessionAttributes.hasMoreElements()
                    ) {

                        String attributeName =
                                sessionAttributes.nextElement();

                        Object attributeValue =
                                session.getAttribute(
                                    attributeName
                                );

                %>

                    <div class="attribute-row">

                        <strong>
                            <%= attributeName %>
                        </strong>

                        =

                        <%= attributeValue %>

                    </div>

                <%

                    }

                %>

            </div>

        </div>



        <!-- ====================================================
             PAGECONTEXT
             ==================================================== -->

        <div class="card">

            <h2>
                📄 PageContext Information
            </h2>


            <div class="info-row">

                <span class="label">
                    Context Path
                </span>

                <span class="value">
                    <%= contextPath %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Server Info
                </span>

                <span class="value">
                    <%= serverInfo %>
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    PageContext
                </span>

                <span class="value">

                    <span class="status">
                        AVAILABLE
                    </span>

                </span>

            </div>

        </div>



        <!-- ====================================================
             JSP LIFECYCLE
             ==================================================== -->

        <div class="card full-width">

            <h2>
                🔄 JSP Processing Cycle & Lifecycle
            </h2>


            <div class="lifecycle">


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        1. JSP Request
                    </span>

                    <br>

                    Browser sends a request for
                    <strong>inspector.jsp</strong>.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        2. Translation
                    </span>

                    <br>

                    Tomcat translates the JSP page
                    into Java Servlet source code.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        3. Compilation
                    </span>

                    <br>

                    The generated Java Servlet source
                    is compiled into a Java class.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        4. Class Loading
                    </span>

                    <br>

                    Tomcat loads the generated
                    servlet class into the JVM.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        5. Initialization
                    </span>

                    <br>

                    The JSP servlet is initialized.
                    The JSP lifecycle begins.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        6. _jspService()
                    </span>

                    <br>

                    The generated servlet processes
                    the client's request and generates
                    the HTML response.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        7. Response
                    </span>

                    <br>

                    Tomcat sends the generated HTML
                    response back to the browser.

                </div>


                <div class="lifecycle-step">

                    <span class="lifecycle-number">
                        8. jspDestroy()
                    </span>

                    <br>

                    When the JSP servlet is removed,
                    its destroy lifecycle method is called.

                </div>

            </div>

        </div>



        <!-- ====================================================
             JSP DIRECTIVES
             ==================================================== -->

        <div class="card full-width">

            <h2>
                📘 JSP Directives Used
            </h2>


            <div class="info-row">

                <span class="label">
                    Page Directive
                </span>

                <span class="value">

                    &lt;%@ page ... %&gt;

                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Language
                </span>

                <span class="value">
                    Java
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Content Type
                </span>

                <span class="value">
                    text/html
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Character Encoding
                </span>

                <span class="value">
                    UTF-8
                </span>

            </div>


            <div class="info-row">

                <span class="label">
                    Session Enabled
                </span>

                <span class="value">
                    true
                </span>

            </div>

        </div>



    </div>

</div>



<!-- ============================================================
     FOOTER
     ============================================================ -->

<footer>

    <strong>
        JSP Anatomy & Lifecycle Inspector
    </strong>

    <br><br>

    Built using JSP Implicit Objects,
    Directives and JSP Lifecycle Concepts.

</footer>


</body>

</html>
```
