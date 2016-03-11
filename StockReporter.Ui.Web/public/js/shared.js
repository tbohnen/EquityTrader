function toJSONLocal (date) {
    var local = new Date(date);
    local.setMinutes(date.getMinutes() - date.getTimezoneOffset());

    return local.toJSON().slice(0, 10);
}

function openReuters(shareIndex){
    window.open('http://www.reuters.com/finance/stocks/financialHighlights?symbol=' + shareIndex + 'J.J','_system');
}

function getMonthFromDate(date){
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  return months[date.getMonth()];
}

function getDateFormattedForUrl(date){
  return date.getDate() + "-" + getMonthFromDate(date) + "-" + date.getFullYear();
}

function getLatestMarketOpenDate(){
  var current = new Date();

  if (isWeekday(current) && 
      (current.getHours() > 9 
       || (current.getHours() == 9 && current.getMinutes() >= 20))){
    return current;
  }

    var date = getPreviousBusinessDay(current);

    return date;
}

function isWeekday(date) {
  var day = date.getDay();
  return day !=0 && day !=6;
}

function getPreviousBusinessDay(date){
  day = date.getDay();


  if (day == 1) return new Date(date.setDate(date.getDate() - 3));
  if (day == 0) return new Date(date.setDate(date.getDate() - 2));

  date = date.setDate(date.getDate() - 1);
  return new Date(date);
}
