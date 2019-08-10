module LoadTransactionsWorkflow

let csvMap (values:string[]) = 
    dict [
        ("")
    ]
let LoadTranactionCsv (csvPath: string) =
    let reader = 
        csvPath
        |> Util.CsvDataProvider.CsvToSeq 