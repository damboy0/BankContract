const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("BankContractModule", function (m) {
  const bankContract = m.contract("BankContract");

  return { bankContract };
});