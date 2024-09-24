const Nodemailer = require("nodemailer");
const { MailtrapTransport } = require("mailtrap");

const TOKEN = "2b5c00d2b5121e8274bbb034e1110e1c";
const ACCOUNT_ID = 2062177; // Replace with your actual account ID

const transport = Nodemailer.createTransport(
  MailtrapTransport({
    token: TOKEN,
    accountId: ACCOUNT_ID, 
    testInboxId: 1727037494,
  })
);

const sender = {
  address: "neelandrakar2001@gmail.com",
  name: "Saee",
};

const recipients = [
  "neelandrakar@gmail.com",
];

transport
  .sendMail({
    from: sender,
    to: recipients,
    subject: "You are awesome!",
    text: "Congrats for sending test email with Mailtrap!",
    category: "Integration Test",
    sandbox: true
  })
  .then(console.log, console.error);