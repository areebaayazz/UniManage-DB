const express = require('express');
const mysql = require('mysql');
const bcrypt = require('bcrypt');
const session = require('express-session');

const app = express();
const port = 3000;
app.set('view engine', 'ejs');
var cors = require('cors')

app.use(cors())



// Set up MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'zain1923',
  database: 'PWB'
});

db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to database');
});

// Set up Express middleware
app.use(express.urlencoded({ extended: false }));
app.use(express.static('public'));
app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/login.html');
  });
  
  app.post('/login', (req, res) => {
    const { email, password } = req.body;
  
// Check if the email and password match the database records
db.query('SELECT * FROM users WHERE email = ? AND password = ?', [email, password], (err, results) => {
  if (err) {
    throw err;
  }

  if (results.length === 1) {
    // Set up the session and redirect to the home page
    var type= "Administrator";
    db.query('SELECT *FROM Users WHERE email = ? AND UserType = ?', [email, type], (err, results) => {

      if(results.length === 1){
      req.session.loggedIn = true;
      res.redirect('/homeAdmin');

      }
    type= "Project Manager";
      db.query('SELECT *FROM Users WHERE email = ? AND UserType = ?', [email, type], (err, results) => {
  
        if(results.length === 1){
        req.session.loggedIn = true;
        res.redirect('/homeManager');
  
        }
      })
      type= "Team Member";
      db.query('SELECT *FROM Users WHERE email = ? AND UserType = ?', [email, type], (err, results) => {
  
        if(results.length === 1){
        req.session.loggedIn = true;
        res.redirect('/homeMember');
  
        }
      })
      type= "Customer";
      db.query('SELECT *FROM Users WHERE email = ? AND UserType = ?', [email, type], (err, results) => {
  
        if(results.length === 1){
        req.session.loggedIn = true;
        res.redirect('/homeCustomer');
  
        }
      })
      


    });



  } else {
    res.status(401).render('login', { error: 'Incorrect email or password.' });
  }
  
  
});

  });
  
  app.get('/home', (req, res) => {
    if (req.session.loggedIn) {
      res.sendFile(__dirname + '/home.html');
    } else {
      res.redirect('/');
    }
  });
  
  app.get('/homeAdmin', (req, res) => {
    if (req.session.loggedIn) {
      res.sendFile(__dirname + '/homeAdmin.html');
    } else {
      res.redirect('/');
    }
  });

  app.get('/homeManager', (req, res) => {
    if (req.session.loggedIn) {
      res.sendFile(__dirname + '/homeManager.html');
    } else {
      res.redirect('/');
    }
  });
  app.get('/homeMember', (req, res) => {
    if (req.session.loggedIn) {
      res.sendFile(__dirname + '/homeMember.html');
    } else {
      res.redirect('/');
    }
  });
  app.get('/homeCustomer', (req, res) => {
    if (req.session.loggedIn) {
      res.sendFile(__dirname + '/homeCustomer.html');
    } else {
      res.redirect('/');
    }
  });
  
  // app.get('/addProject', (req, res) => {
  //   if (req.session.loggedIn) {
  //     res.sendFile(__dirname + '/projectsAdd.html');
  //   } else {
  //     res.redirect('/');
  //   }
  // });


  // Route for fetching data from the Projects table
// app.get('/Addproject', (req, res) => {
//   const query = 'SELECT * FROM Projects';
//   db.query(query, (error, results) => {
//     if (error) {
//       res.status(500).send('Error fetching data from the database');
//     } else {
//       res.json(results)
//     }
//   });
// });



app.get('/Addproject', (req, res) => {
  if (req.session.loggedIn) {
    res.sendFile(__dirname + '/projectsAdd.html');
  } else {
    res.redirect('/');
  }
});

// Route for fetching data from the Projects table
// app.get('/Addproject', (req, res) => {
//   const query = 'SELECT * FROM Projects';
//   db.query(query, (error, results) => {
//     if (error) {
//       console.error('Error fetching data from the database', error);
//       res.status(500).json({ error: 'Error fetching data from the database' });
//     } else {
//       res.json(results);
//     }
//   });
// });


  // app.get('/signup', (req, res) => {
  //   if (1) {
  //     res.sendFile(__dirname + '/signup.html');
  //   } else {
  //     res.redirect('/');
  //   }
  // });
  


  app.post('/signup', (req, res) => {
    res.sendFile(__dirname + '/signup.html');
    const { username, email, usertype, password } = req.body;
  
    const sql = "INSERT INTO Users (UserName, Email, UserType, Password) VALUES (?, ?, ?, ?)";
  
    db.query(sql, [username, email, usertype, password], (error, results) => {
      if (error) {
        console.error(error);
        res.status(500).send('Server error');
      } else {
        res.sendFile(__dirname + '/login.html');
      }
    });
  });

  app.get('/signup', function(req, res){
    res.sendFile(__dirname + '/signup.html');
});

app.get('/boards', function(req, res){
  res.sendFile(__dirname + '/boards.html');
});
app.get('/issues', function(req, res){
  res.sendFile(__dirname + '/issues.html');
});
app.get('/projects', function(req, res){
  res.sendFile(__dirname + '/projects.html');
});
app.get('/reports', function(req, res){
  res.sendFile(__dirname + '/reports.html');
});
app.get('/userManagement', function(req, res){
  res.sendFile(__dirname + '/userManagement.html');
});
app.get('/workflows', function(req, res){
  res.sendFile(__dirname + '/workflows.html');
});

  


  app.get('/logout', (req, res) => {
    req.session.destroy((err) => {
      if (err) {
        throw err;
      }
      res.redirect('/');
    });
  });
  
  // Start the server
  app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
  });
  