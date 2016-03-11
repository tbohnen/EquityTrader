[<EntryPoint>]
let main argv =

  let runToday =
    let date = System.DateTime.Now
    printfn "Generating for: %s" (date.ToString())
    TechnicalAnalysis.TechnicalAnalysisGenerator.generateAllForDate (new System.DateTime(date.Year,date.Month,date.Day, 0,0,0))

  let runFromBeginning (date:System.DateTime) =
    printfn "Running from %s" (date.ToString())
    TechnicalAnalysis.TechnicalAnalysisGenerator.generateAllAfterDate (new System.DateTime(date.Year,date.Month, date.Day))

  match argv with
  | [||] -> printfn "%s" "No Argument supplied"
  | [|x|] when x = "Today" -> runToday
  | [|x;y;|] when x = "FromBeginning" -> runFromBeginning (System.Convert.ToDateTime(argv.GetValue(1).ToString()))
  0 // return an integer exit code
