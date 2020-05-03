const dateFormat = require('dateformat');
module.exports = function (app, request) {
    app.post('/endpoints/accounts/transfer', function (req, res) {
        console.log('Transfer initiated ', req.body);
        var to = req.body.to.match(/\d+/);
        var from = req.body.from.match(/\d+/);
        var params = {
        	  uuid: req.session.user.uuid,
            amount: req.body.amount,
            currency: process.env.CURRENCY,
            description: "Transfer",
            date: dateFormat(new Date(), "mm, dd, yyyy"),
            category: "cash"
        };
        var options = {
            method: 'POST',
            uri: `http://${process.env.TRANSACTIONS_SERVICE_HOST}:${process.env.TRANSACTIONS_SERVICE_PORT}${process.env.CREATE_TRANSACTION_ENDPOINT}`,
            body: params,
            json: true
        };
        request.post(options, function (error, response, body) {
            if (response.statusCode === 500) {
                res.redirect('/accounts.html#failure');
                return;
            }
            var options = {
                 method: 'POST',
                 uri: `http://${process.env.ACCOUNTS_SERVICE_HOST}:${process.env.ACCOUNTS_SERVICE_PORT}${process.env.ACCOUNT_WITHDRAW_ENDPOINT}`,
                 body: {
                   uuid: req.session.user.uuid,
                   amount: req.body.amount,
                   currency: req.body.currency,
                   number: from
                 },
                 json: true
            };
            request.post(options, function (error, response, body) {
              if (response.statusCode==500){
                res.redirect('/accounts.html#failure')
                return;
              }
              var options = {
                method: 'POST',
                uri: `http://${process.env.ACCOUNTS_SERVICE_HOST}:${process.env.ACCOUNTS_SERVICE_PORT}${process.env.ACCOUNT_DEPOSIT_ENDPOINT}`,
                body: {
                  uuid: req.session.user.uuid,
                  amount: req.body.amount,
                  currency: req.body.currency,
                  number: to
                },
                json: true
              };
              request.post(options, function (error, response, body) {
                if (response.statusCode==500){
                  res.redirect('/accounts.html#failure')
                  return;
                }
                res.redirect('/accounts.html#success')
                  return;
              })
            })
        });
    });

    app.get('/endpoints/accounts/activate', function (req, res) {
      var body = {
        uuid: req.session.user.uuid,
        type: req.query.type,
        currency: process.env.CURRENCY
      }
      var options = {
        method: 'POST',
        uri: `http://${process.env.ACCOUNTS_SERVICE_HOST}:${process.env.ACCOUNTS_SERVICE_PORT}${process.env.CREATE_ACCOUNT_ENDPOINT}`,
        body: body,
        json: true
      };
      request.post(options, function (error, response, body) {
        if (response.statusCode==500){
          res.redirect('/accounts.html#failure')
          return;
        }
        res.redirect('/accounts.html#activated')
        return;
      });
    });

    app.post('/endpoints/accounts/get', function (req, res) {
      var options = {
        method: 'POST',
        uri: `http://${process.env.ACCOUNTS_SERVICE_HOST}:${process.env.ACCOUNTS_SERVICE_PORT}${process.env.GET_ACCOUNTS_ENDPOINT}`,
        body: {
          uuid: req.session.user.uuid
        },
        json: true
      };
      request.post(options, function (error, response, body) {
        console.log('accounts for ', req.body,': ', body)
        res.send(body)
      });
    });
};
