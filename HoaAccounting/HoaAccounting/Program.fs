// Learn more about F# at http://fsharp.org

open System

[<EntryPoint>]
let main argv =
    let filesToImport = [
        @"E:\OneDrive\Documents\HOA\Treasurer reports\Savings transactions 2019-05 to 07.csv"
        @"E:\OneDrive\Documents\HOA\Treasurer reports\Checking transactions 2019-05 to 07.csv"
    ]
    filesToImport
    |> List.iter LoadTransactionsWorkflow.LoadTranactionCsv
    printfn "Done!"
    0 // return an integer exit code
