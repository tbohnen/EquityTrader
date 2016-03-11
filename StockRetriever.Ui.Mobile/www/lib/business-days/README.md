#Business Days

`npm install business-days`

```javascript
var bd = require('business-days');
var day = new Date(2013, 8, 20); // Fri 9/20/13
var nextBusinessDay = bd(1, day.getFullYear(), day.getMonth(), day.getDate());
console.log(nextBusinessDay.toISOString()); // 2013-09-23T07:00:00.000Z (a Monday)
```

Negative time works, and if you can also call bd with one arg and that will
assume you mean today as a reference.

