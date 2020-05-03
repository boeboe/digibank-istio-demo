module.exports = function (request, dateFormat) {
    var randomEntries = {
        bills: [
            {
                category: 'utilities',
                entity: 'DEWA'
            },
            {
                category: 'home_entertainment',
                entity: 'Etisalat'
            },
            {
                category: 'mobile_phone',
                entity: 'Du'
            },
            {
                category: 'credit_card',
                entity: 'Innovate'
            },
            {
                category: 'internet',
                entity: 'AT&T'
            },
            {
                category: 'fuel_card',
                entity: 'Total'
            }
        ],
        transactions: [
            {
                category: 'groceries',
                description: [
                    'Carrefour',
                    'Lulu Hypermarket',
                    'Geant',
                    'Waitrose',
                    'Spinneys',
                    'Intermarché',
                    'Woolsworth',
                    'Kroger',
                    'Delhaize',
                    'Albert Heijn',
                    'Aldi',
                    'The Kroger Co',
                    'Albertsons Companies'
                ]
            },
            {
                category: 'eating_out',
                description: [
                    'Krush Burgers',
                    'Clinton Baking St',
                    'Mamaeesh',
                    'Starbucks',
                    'Costa Coffee',
                    'Blaze Burgers',
                    'Cheesecake Factory',
                    'Noma',
                    'Celler de Can Roca',
                    'Osteria Francescana',
                    'Eleven Madison Park',
                    'Mugaritz',
                    'Arzak',
                    'Alinea',
                    'The Ledbury',
                    'KFC',
                    'McDonalds',
                    'Burger King',
                    'Pizza Hut'
                ]
            },
            {
                category: 'transport',
                description: [
                    'Uber',
                    'Careem',
                    'Lyft',
                    'Didi Chuxing',
                    'Lime',
                    'Waymo'
                ]
            },
            {
                category: 'bills',
                description: [
                    'Utilities',
                    'Home entertainment',
                    'Phone',
                    'Credit card',
                    'Internet subscription'
                ]
            },
            {
                category: 'expenses',
                description: [
                    'Municipality fee',
                    'VAT',
                    'Shopping',
                    'Electronics',
                    'Shoes'
                ]
            },
            {
                category: 'cash',
                description: [
                    'Withdrawal',
                    'Transfer'
                ]
            },
            {
                category: 'holidays',
                description: [
                    'Flight ticket',
                    'Hotel booking',
                    'Car rental',
                    'Museum visit'
                ]
            }
        ]
    };

    function createTransaction(uuid) {
        let amount = Math.floor(Math.random() * Math.floor(1200)) + '';
        let date = dateFormat(new Date(), "mm, dd, yyyy");
        let randomCategoryIndex = Math.floor(Math.random() * Math.floor(randomEntries.transactions.length));
        let randomDescriptionIndex = Math.floor(Math.random() * Math.floor(randomEntries.transactions[randomCategoryIndex].description.length));
        var body = {
            uuid: uuid,
            amount: amount,
            currency: process.env.CURRENCY,
            category: randomEntries.transactions[randomCategoryIndex].category,
            description: randomEntries.transactions[randomCategoryIndex].description[randomDescriptionIndex],
            date: date
        };
        console.log('Adding transaction: ');
        console.log(body);
        var options = {
            method: 'POST',
            uri: `http://${process.env.TRANSACTIONS_ADDRESS}:${process.env.TRANSACTIONS_PORT}${process.env.CREATE_TRANSACTION_ENDPOINT}`,
            body: body,
            json: true
        };
        request.post(options, function (err, response, body) {
            return;
        });
    }

    function createBill(uuid) {
        let randomIndex = Math.floor(Math.random() * Math.floor(randomEntries.bills.length));
        let amount = Math.floor(Math.random() * Math.floor(1200)) + '';
        let date = dateFormat(new Date(), "mm, dd, yyyy");
        let account_no = Math.floor(Math.random() * 90000000) + '';
        var body = {
            uuid: uuid,
            category: randomEntries.bills[randomIndex].category,
            entity: randomEntries.bills[randomIndex].entity,
            amount: amount,
            currency: process.env.CURRENCY,
            date: date,
            account_no: account_no
        };
        console.log('Adding bill: ');
        console.log(body);
        var options = {
            method: 'POST',
            uri: `http://${process.env.BILLS_ADDRESS}:${process.env.BILLS_PORT}${process.env.UPSERT_BILL_ENDPOINT}`,
            body: body,
            json: true
        };
        request.post(options, function (err, response, body) {
            return;
        });
    }

    function dropBills() {
        var options = {
            method: 'GET',
            uri: `http://${process.env.BILLS_ADDRESS}:${process.env.BILLS_PORT}${process.env.DROP_BILLS_ENDPOINT}`,
            json: true
        };
        request.get(options, function (err, response, body) {
            return;
        });
    }

    function dropTransactions() {
        var options = {
            method: 'GET',
            uri: `http://${process.env.TRANSACTIONS_ADDRESS}:${process.env.TRANSACTIONS_PORT}${process.env.DROP_TRANSACTIONS_ENDPOINT}`,
            json: true
        };
        request.get(options, function (err, response, body) {
            return;
        });
    }

    function dropAccounts() {
        var options = {
            method: 'GET',
            uri: `http://${process.env.ACCOUNTS_ADDRESS}:${process.env.ACCOUNTS_PORT}${process.env.DROP_ACCOUNTS_ENDPOINT}`,
            json: true
        };
        request.get(options, function (err, response, body) {
            return;
        });
    }

    function populate() {
        console.log('Populating');
        return new Promise(function (resolve, reject) {
            var options = {
                method: 'GET',
                uri: `http://${process.env.AUTHENTICATION_ADDRESS}:${process.env.AUTHENTICATION_PORT}${process.env.GET_USERS_ENDPOINT}`,
                json: true
            };
            request.get(options, function (err, response, body) {
                if (err) {
                    reject(err);
                }
                resolve(body);
            });
        })
        .then(function (users) {
            console.log(users);
            for (index in users) {
                createBill(users[index].uuid);
                createTransaction(users[index].uuid);
            }
            return;
        })
        .catch(function (err) {
            console.log('Failed to retrieve users; ', err);
            return;
        });
    }

    function reset() {
        console.log('Resetting');
        dropAccounts();
        dropTransactions();
        dropBills();
        return;
    }

    function init() {
        setInterval(reset, 36000000);
        setInterval(populate, 18000);
    }

    reset();
    populate();
    init();

};
