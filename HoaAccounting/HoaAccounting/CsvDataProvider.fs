namespace Util

module CsvDataProvider =
    open System.Data
    open System.IO
    open CsvParser
    open System.Text
    open System.Linq

    let private toDict (headers:string[]) (values:string[]) =
        seq {
            for idx = 0 to (headers.Length - 1) do
                yield (headers.[idx].Trim().ToUpper(), values.[idx].Trim().Trim('"'))
        }
        |> dict
    let CsvToSeq (rowMapper:string[] -> 'a) (filePath: string) =
        seq {
            use stream = File.OpenRead(filePath)
            use parser = new CsvParser.CsvReader(stream, Encoding.UTF8, new CsvParser.CsvReader.Config(WithQuotes = true))
            while (parser.MoveNext()) do
                yield (parser.Current.ToArray() |> rowMapper)
        }
        
