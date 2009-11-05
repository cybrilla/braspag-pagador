require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Braspag::Pagador do
  before do
    @merchant_id = "{84BE7E7F-698A-6C74-F820-AE359C2A07C2}"
    @connection = Braspag::Connection.new(@merchant_id, :test)
    @pagador = Braspag::Pagador.new(@connection)
    response = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><soap:Body><AuthorizeResponse xmlns='https://www.pagador.com.br/webservice/pagador'><AuthorizeResult><amount>1</amount><authorisationNumber>418270</authorisationNumber><message>Transaction Sucessful</message><returnCode>0</returnCode><status>1</status><transactionId>128199</transactionId></AuthorizeResult></AuthorizeResponse></soap:Body></soap:Envelope>"
    mock_response @pagador, response
  end

  it "deve enviar dados para webservice de autorizacao" do
    expected = <<STRING
<?xml version='1.0' ?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
  <env:Header />
  <env:Body>
    <tns:Authorize xmlns:tns="https://www.pagador.com.br/webservice/pagador">
      <tns:merchantId>#{@merchant_id}</tns:merchantId>
      <tns:orderId>teste564</tns:orderId>
      <tns:customerName>comprador de teste</tns:customerName>
      <tns:amount>1,00</tns:amount>
      <tns:paymentMethod>18</tns:paymentMethod>
      <tns:holder>comprador de teste</tns:holder>
      <tns:cardNumber>345678901234564</tns:cardNumber>
      <tns:expiration>06/11</tns:expiration>
      <tns:securityCode>1234</tns:securityCode>
      <tns:numberPayments>1</tns:numberPayments>
      <tns:typePayment>0</tns:typePayment>
    </tns:Authorize>
  </env:Body>
</env:Envelope>
STRING
    response_should_contain(expected)
    @pagador.authorize(:orderId => "teste564", :customerName => "comprador de teste", :amount => "1,00", :paymentMethod => "18", :holder => "comprador de teste", :cardNumber => "345678901234564", :expiration => "06/11", :securityCode => "1234", :numberPayments => "1", :typePayment => "0" )
  end

  it "deve devolver o resoltado em um mapa" do
    map = {"amount" =>"1", "authorisationNumber" => "418270", "message" => "Transaction Sucessful", "returnCode" => "0", "status" => "1", "transactionId" => "128199"}
    @pagador.authorize(:orderId => "teste564", :customerName => "comprador de teste", :amount => "1,00", :paymentMethod => "18", :holder => "comprador de teste", :cardNumber => "345678901234564", :expiration => "06/11", :securityCode => "1234", :numberPayments => "1", :typePayment => "0" ).should == map
  end
end
