JsOsaDAS1.001.00bplist00�Vscript_>var app = Application.currentApplication()
app.includeStandardAdditions = true

function run(argv) {
  // console.log(JSON.stringify(argv))

  var document = app.chooseFile({
      withPrompt: "Select files",
  	  // ofType: ["rda","pdf"],
	  ofType: argv,
	  multipleSelectionsAllowed: true
  })
  return document;
}
                              Tjscr  ��ޭ