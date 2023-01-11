export class LoginPage {
  constructor() {
    this.usernameInput = "input#email";
    this.passwordInput = "input#current-password";
    this.signInButton = "input.submitBtn";
  }

  goToLoginPage() {
    cy.clearCookies();
    cy.visit("/").wait(3000);
    return this;
  }

  loginWithUser(email = "", password = "") {
    if (email != "") cy.get(this.usernameInput).click().type(email);
    // if (password != "")
    //   cy.get("flt-glass-pane")
    //     .shadow()
    //     .find(this.passwordInput)
    //     .type("abc", { force: true });

    // cy.get(this.signInButton).click();
    return this;
  }
}
