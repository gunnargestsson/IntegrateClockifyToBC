codeunit 70653 "Clockify Http Request"
{
    procedure AddReplaceContentHeader(var Request: HttpRequestMessage; HeaderName: Text; HeaderValue: Text)
    var
        Headers: HttpHeaders;
    begin
        Request.Content().GetHeaders(Headers);
        if Headers.Contains(HeaderName) then
            Headers.Remove(HeaderName);
        Headers.Add(HeaderName, HeaderValue);
    end;

    procedure ReadAsJson(var Response: HttpResponseMessage) Json: JsonToken
    var
        JsonAsText: Text;
    begin
        Response.Content().ReadAs(JsonAsText);
        Json.ReadFrom(JsonAsText);
    end;

    procedure SendRequest(var Request: HttpRequestMessage; var Response: HttpResponseMessage)
    var
        Client: HttpClient;
    begin
        Client.Send(Request, Response);
        ThrowErrorIfNotSuccess(Response);
    end;

    procedure SetRequest(Url: Text; Method: Text; APIKey: Text; var Request: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        Clear(Request);
        Request.Method(Method);
        Request.SetRequestUri(Url);
        Request.GetHeaders(Headers);
        Headers.Add('X-Api-Key', APIKey);
    end;

    procedure SetRequestContent(var Request: HttpRequestMessage; ContentType: Text; ContentJson: JsonToken)
    var
        ContentText: Text;
    begin
        ContentJson.WriteTo(ContentText);
        Request.Content().WriteFrom(ContentText);
        AddReplaceContentHeader(Request, 'Content-Type', ContentType);
    end;

    local procedure ThrowErrorIfNotSuccess(var Response: HttpResponseMessage)
    var
        ResponseError: Text;
    begin
        if Response.IsSuccessStatusCode() then exit;
        Response.Content.ReadAs(ResponseError);
        Error('%1:%2\\%3', Response.HttpStatusCode(), Response.ReasonPhrase(), ResponseError);
    end;
}