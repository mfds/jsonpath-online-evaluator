class JsonPathOnlineEvaluator
  constructor: ->
    @editor = ace.edit("json-editor");
    @editor.setTheme("ace/theme/solarized_dark")
    @editor.getSession().setMode("ace/mode/json")

    @resultEditor = ace.edit("result-editor")
    @resultEditor.setTheme("ace/theme/solarized_dark")
    @resultEditor.getSession().setMode("ace/mode/json")
    @resultEditor.setReadOnly(true);

    $('input').on 'textchange', @evaluate
    @editor.on 'change', @evaluate

    @evaluate()

  evaluate: =>
    query = $('input').val()
    json_str = @editor.getValue()

    try
      json = JSON.parse(json_str.replace(/(\r\n|\n|\r)/gm, ''))
      $('#json-area').removeClass('has-error');
      $('#json-alert').text('');
    catch
      @resultEditor.getSession().setValue 'Json Parse Error'
      return

    result = JSONPath(
      json: json
      path: query
    )

    console.debug(result)
    unless _.isEmpty(result)
      @resultEditor.getSession().setValue JSON.stringify(result, undefined, 2)
    else
      @resultEditor.getSession().setValue 'No match'

$ ->
  new JsonPathOnlineEvaluator()
