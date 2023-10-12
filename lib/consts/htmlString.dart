// ignore_for_file: file_names

class HtmlString {
  static String htmlString(String html) {
    return """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
    iframe{
      width:100%;
    }
    </style>
    </head>
    <body>
    $html
    </body>
    </html>
     """;
  }
}
