class user{
  int id;
  String invoiceNumber;
  String type;
  String storeName;
  String subtotal;
  String date;
  String concept;

  int dayR;
  int monthR;
  int yearR;

  user(
    {
      this.id,
      this.invoiceNumber,
      this.type,
      this.storeName,
      this.subtotal,
      this.date,
      this.concept,

      this.dayR,
      this.monthR,
      this.yearR,
    }
  );

  user.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      invoiceNumber = res['invoiceNumber'],
      type = res['type'],
      storeName = res['storeName'],
      subtotal = res['subtotal'],
      date = res['date'],
      concept = res['concept'],
      
      dayR = res['dayR'],
      monthR = res['monthR'],
      yearR = res['yearR'];
  
  Map<String, Object> toMap(){
    return {
      'id' : id,
      'invoiceNumber' : invoiceNumber,
      'type' : type,
      'storeName' : storeName,
      'subtotal' : subtotal,
      'date': date,
      'concept': concept,

      'dayR': dayR,
      'monthR': monthR,
      'yearR': yearR,
    };
  }
 
}