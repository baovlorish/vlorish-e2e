/// <reference types="Cypress" />
const { LoginPage } = require("../pages/loginPage");
import user from "../fixtures/userData.json";

const loginPage = new LoginPage();
describe("Login Functionality", () => {
  beforeEach(function () {
    loginPage.goToLoginPage();
  });

  it("Login with valid user", { includeShadowDom: true }, () => {
    loginPage.loginWithUser(user.valid.email, user.valid.password);
  });
});
