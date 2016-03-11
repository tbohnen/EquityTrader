namespace TechnicalAnalysisIndicators
module MovementCalculatorTests =
  open NUnit.Framework
  open FsUnit
  open System
  open MovementCalculator

  let testDate = new DateTime(2015,5,11)

  [<Test>]
  let ``Calculate movement for date`` () =
    MovementCalculator.daysMovement testDate "SHF" 1 |> should equal 1.12m

  [<Test>]
  let ``Calculate Movement for 14 days`` () =
    MovementCalculator.daysMovement testDate "SHF" 14 |> should equal -1.92m

    let subtractone days =
      let newDay = days - 1
      newDay

    let rec printdays (days:int) =
      ((MovementCalculator.daysMovement (DateTime.Now.AddDays(float -days)) "SHF" days).ToString()) |> ignore

      match DateTime.Now.AddDays(float -days) with
        | x  when x < DateTime.Now -> days - 1 |> printdays
        | _ -> 0

    printdays 100 |> ignore
