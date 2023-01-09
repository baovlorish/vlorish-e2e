// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })
Cypress.Commands.add(
  'login',
  (username = Cypress.env('EMAIL'), password = Cypress.env('PASSWORD')) => {
    cy.visit(Cypress.env('login_url'));
    cy.get('#email').clear().type(username);
    cy.get('#password').clear().type(password);
    cy.get('[label=Submit]').click();
    cy.url().should('include', Cypress.env('dashboard_url'));
    Cypress.Cookies.preserveOnce('r-1-auth');
  },
);

Cypress.Commands.add("forceVisit", (url) => {
  cy.get("body").then((body$) => {
    const appWindow = body$[0].ownerDocument.defaultView || window;
    const appIframe = appWindow.parent.document.querySelector("iframe") || window;
    return new Promise((resolve) => {
      appIframe.onload = () => resolve();
      appWindow.location = url;
    });
  });
});

