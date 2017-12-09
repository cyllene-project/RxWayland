class Scanner : XMLParserDelegate {

    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()

   
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement=elementName;
        
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=true;
            }
            passData=true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=false;
            }
            passData=false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData=strXMLData+"\n\n"+string
        }
        
        if(passData)
        {
            print(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }



}
