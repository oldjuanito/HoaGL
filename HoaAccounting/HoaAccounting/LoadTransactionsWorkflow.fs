module LoadTransactionsWorkflow

open Puppy.SqlMapper
open PuppyData.SimpleWorkflow

let connStr = "Data Source=.\\sqlexpress;Initial Catalog=HoaAccounting;Integrated Security=True;MultipleActiveResultSets=True"

let csvMap accountId (values:string[]) = 
    let optionalCheckNumber = values.[3]
    dict [
        ("AccountId", accountId |> box)
        ("TransactionDate", values.[0] |> box)
        ("Amount", values.[1] |> box)
        ("OptionalCheckNumber", if optionalCheckNumber |> System.String.IsNullOrEmpty then null else optionalCheckNumber |> box)
        ("Description", values.[4] |> box)
        ("ReportDescription", values.[5] |> box)
    ]

let private createWorkflowEngine() =
    let engine = new Execution.ExecutionEngine()
    let stepTypesBuilders = dict [
        (1, StoredProcStep.BuildStep)
        (2, ExecWorkflowStep.BuildStep (engine.ExecuteWorkflow))
        (3, DotNetFuncStep.BuildStep)
    ] 
    let conditionTypesBuilders = dict [
        (1, PatternMatchCondition.BuildCondition)
    ]
    engine.ConditionTypesBuilders <- conditionTypesBuilders
    let errMapperTypesBuilders = dict [
        (1, SpResultErrorMapper.Build)
    ]
    engine.ErrorMapTypesBuilders <- errMapperTypesBuilders
    engine.StepTypesBuilders <- stepTypesBuilders
    engine

let private runImportWorkflow (engine:Execution.ExecutionEngine) (rowData) =
    async {
        let workflowId = 1
        let! finalResult = engine.ExecuteWorkflow connStr workflowId rowData 
        printfn "%A" finalResult.CurrentData.Errors
    } |> Async.RunSynchronously

let LoadTranactionCsv (csvPath: string) =
    let engine = createWorkflowEngine()
    let accountId = if csvPath.ToUpper().Contains("SAVINGS") then 2 else 1 
    
    csvPath
    |> Util.CsvDataProvider.CsvToSeq (csvMap accountId)
    |> Seq.iter (runImportWorkflow engine)