```diff
 pragma solidity ^0.6.0;
 
-import "../../GSN/Context.sol";
-import "./IERC777.sol";
-import "./IERC777Recipient.sol";
-import "./IERC777Sender.sol";
-import "../../token/ERC20/IERC20.sol";
-import "../../math/SafeMath.sol";
-import "../../utils/Address.sol";
-import "../../introspection/IERC1820Registry.sol";
+import "@openzeppelin/contracts/GSN/Context.sol";
+import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
+import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
+import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
+import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
+import "@openzeppelin/contracts/math/SafeMath.sol";
+import "@openzeppelin/contracts/utils/Address.sol";
+import "@openzeppelin/contracts/introspection/IERC1820Registry.sol";
 
 /**
  * @dev Implementation of the {IERC777} interface.
  contract ERC777 is Context, IERC777, IERC20 {
 
     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
 
-    mapping(address => uint256) private _balances;
+    mapping(address => uint256) internal _balances;
 
-    uint256 private _totalSupply;
+    uint256 internal _totalSupply;
 
     string private _name;
     string private _symbol;
  contract ERC777 is Context, IERC777, IERC20 {
     /**
      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
      */
-    function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
+    function balanceOf(address tokenHolder) virtual public view override(IERC20, IERC777) returns (uint256) {
         return _balances[tokenHolder];
     }
 
  contract ERC777 is Context, IERC777, IERC20 {
         bytes memory userData,
         bytes memory operatorData
     )
-        private
+        internal virtual
     {
         _beforeTokenTransfer(operator, from, to, amount);
 
  contract ERC777 is Context, IERC777, IERC20 {
         bytes memory userData,
         bytes memory operatorData
     )
-        private
+        internal
     {
         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
         if (implementer != address(0)) {
  contract ERC777 is Context, IERC777, IERC20 {
      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
      */
     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
-}
+}
```
