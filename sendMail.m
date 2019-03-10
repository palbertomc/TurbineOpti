function sendMail(receipient,subject,message)

% Function to send email to user regarding failed meshing / or CFD
%
% Input:
%   receipient -    string containing destination email address
%   subject -       string containing email subject
%   message -       string containing email message
%
% Output:
%   null
%
% J Bergh, 2014

% User account and password
mail = '***REMOVED***';
password = '***REMOVED***';

% Set up Gmail SMTP service.
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email
sendmail(receipient,subject,message)