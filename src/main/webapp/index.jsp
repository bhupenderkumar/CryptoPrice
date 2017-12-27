<!DOCTYPE html>
<html>

<head>
<title>Crypto Currency Price</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>


</head>



<script src="js/angular.min.js"></script>
<script type="text/javascript" src="js/ngStorage.min.js"></script>
<body>

	<div ng-app="myApp">
		<div ng-controller="priceCtrl">
			<div ng-if="crypto!=undefined ">
				Testing Price controller ...Total Price <B>{{totalPrice}}</B> <br>
				<div>
					what you brought : CryptoCurrency Name : <select
						ng-options="item as item.name for item in crypto track by item.id"
						ng-model="userCrypto.crypto"><option>Select</option>
					</select> In how much quantity <input type="text"
						ng-model="userCrypto.quantity"> In which Currency you want
					your price <select ng-model="userCrypto.currency">
						<option ng-repeat="(key,val) in currencies" value="{{val}}"
							selected="selected">{{val}}-{{key}}</option>
					</select><input type="button" value="Add" ng-click="addCrypto()" />
				</div>
			</div>
			<div ng-if="crypto==undefined ">Loading</div>
			<div class="container" ng-if="existingCrypto.length>0">
				<h2>Your Records</h2>
				<table class="table">
					<thead>
						<tr>
							<th>Currency Name</th>
							<th>Currency Quantity</th>
							<th>Required Currency</th>
							<th>Current Price</th>
							<th>Previous Checked Price</th>
							<th>Remove This</th>
						</tr>
					</thead>
					<tbody>
						<tr ng-repeat="obj in existingCrypto">

							<td>{{obj.crypto.name}}</td>
							<td>{{obj.quantity}}</td>
							<td>{{obj.currency}}</td>
							<td>{{obj.yourPrice}}</td>
							<td>{{obj.prevCheckedPrice}}</td>
							<td title="Delete This Crypto" ng-click="removeThis($index)"
								style="color: blue; mouse: hand;"><span>Delete</span></td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 			<div ng-repeat="obj in existingCrypto"> -->
			<!-- 				{{obj.crypto.name}}-{{obj.quantity}}-{{obj.currency}} - -->
			<!-- 				{{obj.yourPrice}}</div> -->
		</div>

	</div>
	<script>
		var app = angular.module('myApp', [ "ngStorage" ]);
		app
				.controller(
						'priceCtrl',
						function($scope, $http, $localStorage, $sessionStorage,
								$window, $timeout) {
							$scope.removeThis = function(index) {
								$scope.existingCrypto.splice(index, 1);
								$scope.refreshDetails();
							}
							$scope.existingCrypto = $localStorage.existingCrypto;
							$scope.totalPrice = $localStorage.totalPrice;
							if (undefined === $localStorage.existingCrypto) {
								$scope.existingCrypto = [];
								alert("No Item Found in Your Local Storage");
							}
							$scope.userCrypto = {};
							$timeout(
									function() {

										$http
												.get(
														"https://api.coinmarketcap.com/v1/ticker/")
												.then(
														function(response) {
															// 				alert(response.length);
															$scope.crypto = response.data;
															$scope
																	.refreshDetails();
															// 							console.log(response);
														});
									}, 5000);

							$scope.refreshDetails = function() {
								for (var count = 0; count < $scope.existingCrypto.length; count++) {

									for (var i = 0; i < $scope.crypto.length; i++) {
										if (angular
												.equals(
														$scope.existingCrypto[count].crypto.name,
														$scope.crypto[i].name)) {
											flag = true;
											console
													.log($scope.existingCrypto[count].crypto);
											console.log($scope.crypto[i])
										}
										if (angular
												.equals(
														$scope.existingCrypto[count].crypto.name,
														$scope.crypto[i].name)) {
											// 						console.log($scope.existingCrypto[count]);
											// 						console.log($scope.existingCrypto[count].yourPrice);
											$scope.existingCrypto[count].prevCheckedPrice = $scope.existingCrypto[count].yourPrice;
											$scope.existingCrypto[count].yourPrice = $scope.existingCrypto[count].quantity
													* $scope.crypto[i].price_usd;
											// 						console.log($scope.existingCrypto[count].yourPrice)
										}

									}

								}
								$scope.calculateTotalPrice();
							}
							$scope.addCrypto = function() {
								var crypto = angular.copy($scope.userCrypto);
								console.log(crypto);
								for (var i = 0; i < $scope.crypto.length; i++) {
									if (angular.equals(crypto.crypto,
											$scope.crypto[i])) {
										// 						alert($scope.crypto[i].price_usd);
										console.log(crypto.quantity
												* $scope.crypto[i].price_usd);
										crypto.yourPrice = crypto.quantity
												* $scope.crypto[i].price_usd;
									}

								}
								$scope.userCrypto = {};
								$scope.userCrypto.crypto = {};
								$scope.existingCrypto.push(crypto);

								console.log($scope.totalPrice)
								$localStorage.existingCrypto = $scope.existingCrypto;

								$scope.calculateTotalPrice();
								// 				$scope.userCryptpo=undefined;

							}

							$scope.calculateTotalPrice = function() {
								$scope.totalPrice = 0.0;
								for (var i = 0; i < $scope.existingCrypto.length; i++) {

									$scope.totalPrice += $scope.existingCrypto[i].yourPrice;
								}
								$localStorage.totalPrice = $scope.totalPrice;
							}

							$scope.refresh = function() {

							}

							$scope.$watch("existingCrypto", function(value) {

							});
							$scope.currencies = {
								"USD" : "United States Dollar",
							};

						});
	</script>

</body>
</html>
