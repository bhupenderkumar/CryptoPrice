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
							<th>Your Currency Price</th>
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
							<td>{{obj.yourCurrPrice}}</td>
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
								for ( var shortCurr in $scope.currencies) {
									var key = angular.copy(shortCurr);
									var value = $scope.currencies[key];
									// 									alert(shortCurr)
									if (angular.equals(value, crypto.currency)) {
										var temp = angular.copy(key);
										$http
												.get(
														"https://api.fixer.io/latest?symbols=USD,"
																+ key)
												.then(
														function(response) {
															// 				alert(response.length);

															console
																	.log(response);
															var data = response.data;
															var rates = data.rates;
															// 															alert(temp);
															for (key1 in rates) {
																console
																		.log(key1)
																console
																		.log(temp);
																if (temp === key1) {
																	crypto.yourCurrPrice = crypto.yourPrice
																			* rates[key1];
																	console
																			.log(temp
																					+ "== "
																					+ rates[key1]);
																	alert();
																}
															}
															// 														alert(key);
															// 														alert(value);

															// 							console.log(response);
														});

									}

								}
								$scope.userCrypto = {};
								$scope.userCrypto.crypto = {};
								$scope.existingCrypto.push(crypto);

								console.log($scope.totalPrice);

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
								"AED" : "United Arab Emirates Dirham",
								"AFN" : "Afghan Afghani",
								"ALL" : "Albanian Lek",
								"AMD" : "Armenian Dram",
								"ANG" : "Netherlands Antillean Guilder",
								"AOA" : "Angolan Kwanza",
								"ARS" : "Argentine Peso",
								"AUD" : "Australian Dollar",
								"AWG" : "Aruban Florin",
								"AZN" : "Azerbaijani Manat",
								"BAM" : "Bosnia-Herzegovina Convertible Mark",
								"BBD" : "Barbadian Dollar",
								"BDT" : "Bangladeshi Taka",
								"BGN" : "Bulgarian Lev",
								"BHD" : "Bahraini Dinar",
								"BIF" : "Burundian Franc",
								"BMD" : "Bermudan Dollar",
								"BND" : "Brunei Dollar",
								"BOB" : "Bolivian Boliviano",
								"BRL" : "Brazilian Real",
								"BSD" : "Bahamian Dollar",
								"BTC" : "Bitcoin",
								"BTN" : "Bhutanese Ngultrum",
								"BWP" : "Botswanan Pula",
								"BYN" : "Belarusian Ruble",
								"BZD" : "Belize Dollar",
								"CAD" : "Canadian Dollar",
								"CDF" : "Congolese Franc",
								"CHF" : "Swiss Franc",
								"CLF" : "Chilean Unit of Account (UF)",
								"CLP" : "Chilean Peso",
								"CNH" : "Chinese Yuan (Offshore)",
								"CNY" : "Chinese Yuan",
								"COP" : "Colombian Peso",
								"CRC" : "Costa Rican Colón",
								"CUC" : "Cuban Convertible Peso",
								"CUP" : "Cuban Peso",
								"CVE" : "Cape Verdean Escudo",
								"CZK" : "Czech Republic Koruna",
								"DJF" : "Djiboutian Franc",
								"DKK" : "Danish Krone",
								"DOP" : "Dominican Peso",
								"DZD" : "Algerian Dinar",
								"EGP" : "Egyptian Pound",
								"ERN" : "Eritrean Nakfa",
								"ETB" : "Ethiopian Birr",
								"EUR" : "Euro",
								"FJD" : "Fijian Dollar",
								"FKP" : "Falkland Islands Pound",
								"GBP" : "British Pound Sterling",
								"GEL" : "Georgian Lari",
								"GGP" : "Guernsey Pound",
								"GHS" : "Ghanaian Cedi",
								"GIP" : "Gibraltar Pound",
								"GMD" : "Gambian Dalasi",
								"GNF" : "Guinean Franc",
								"GTQ" : "Guatemalan Quetzal",
								"GYD" : "Guyanaese Dollar",
								"HKD" : "Hong Kong Dollar",
								"HNL" : "Honduran Lempira",
								"HRK" : "Croatian Kuna",
								"HTG" : "Haitian Gourde",
								"HUF" : "Hungarian Forint",
								"IDR" : "Indonesian Rupiah",
								"ILS" : "Israeli New Sheqel",
								"IMP" : "Manx pound",
								"INR" : "Indian Rupee",
								"IQD" : "Iraqi Dinar",
								"IRR" : "Iranian Rial",
								"ISK" : "Icelandic Króna",
								"JEP" : "Jersey Pound",
								"JMD" : "Jamaican Dollar",
								"JOD" : "Jordanian Dinar",
								"JPY" : "Japanese Yen",
								"KES" : "Kenyan Shilling",
								"KGS" : "Kyrgystani Som",
								"KHR" : "Cambodian Riel",
								"KMF" : "Comorian Franc",
								"KPW" : "North Korean Won",
								"KRW" : "South Korean Won",
								"KWD" : "Kuwaiti Dinar",
								"KYD" : "Cayman Islands Dollar",
								"KZT" : "Kazakhstani Tenge",
								"LAK" : "Laotian Kip",
								"LBP" : "Lebanese Pound",
								"LKR" : "Sri Lankan Rupee",
								"LRD" : "Liberian Dollar",
								"LSL" : "Lesotho Loti",
								"LYD" : "Libyan Dinar",
								"MAD" : "Moroccan Dirham",
								"MDL" : "Moldovan Leu",
								"MGA" : "Malagasy Ariary",
								"MKD" : "Macedonian Denar",
								"MMK" : "Myanma Kyat",
								"MNT" : "Mongolian Tugrik",
								"MOP" : "Macanese Pataca",
								"MRO" : "Mauritanian Ouguiya (pre-2018)",
								"MUR" : "Mauritian Rupee",
								"MVR" : "Maldivian Rufiyaa",
								"MWK" : "Malawian Kwacha",
								"MXN" : "Mexican Peso",
								"MYR" : "Malaysian Ringgit",
								"MZN" : "Mozambican Metical",
								"NAD" : "Namibian Dollar",
								"NGN" : "Nigerian Naira",
								"NIO" : "Nicaraguan Córdoba",
								"NOK" : "Norwegian Krone",
								"NPR" : "Nepalese Rupee",
								"NZD" : "New Zealand Dollar",
								"OMR" : "Omani Rial",
								"PAB" : "Panamanian Balboa",
								"PEN" : "Peruvian Nuevo Sol",
								"PGK" : "Papua New Guinean Kina",
								"PHP" : "Philippine Peso",
								"PKR" : "Pakistani Rupee",
								"PLN" : "Polish Zloty",
								"PYG" : "Paraguayan Guarani",
								"QAR" : "Qatari Rial",
								"RON" : "Romanian Leu",
								"RSD" : "Serbian Dinar",
								"RUB" : "Russian Ruble",
								"RWF" : "Rwandan Franc",
								"SAR" : "Saudi Riyal",
								"SBD" : "Solomon Islands Dollar",
								"SCR" : "Seychellois Rupee",
								"SDG" : "Sudanese Pound",
								"SEK" : "Swedish Krona",
								"SGD" : "Singapore Dollar",
								"SHP" : "Saint Helena Pound",
								"SLL" : "Sierra Leonean Leone",
								"SOS" : "Somali Shilling",
								"SRD" : "Surinamese Dollar",
								"SSP" : "South Sudanese Pound",
								"STD" : "São Tomé and Príncipe Dobra (pre-2018)",
								"SVC" : "Salvadoran Colón",
								"SYP" : "Syrian Pound",
								"SZL" : "Swazi Lilangeni",
								"THB" : "Thai Baht",
								"TJS" : "Tajikistani Somoni",
								"TMT" : "Turkmenistani Manat",
								"TND" : "Tunisian Dinar",
								"TOP" : "Tongan Pa'anga",
								"TRY" : "Turkish Lira",
								"TTD" : "Trinidad and Tobago Dollar",
								"TWD" : "New Taiwan Dollar",
								"TZS" : "Tanzanian Shilling",
								"UAH" : "Ukrainian Hryvnia",
								"UGX" : "Ugandan Shilling",
								"USD" : "United States Dollar",
								"UYU" : "Uruguayan Peso",
								"UZS" : "Uzbekistan Som",
								"VEF" : "Venezuelan Bolívar Fuerte",
								"VND" : "Vietnamese Dong",
								"VUV" : "Vanuatu Vatu",
								"WST" : "Samoan Tala",
								"XAF" : "CFA Franc BEAC",
								"XAG" : "Silver Ounce",
								"XAU" : "Gold Ounce",
								"XCD" : "East Caribbean Dollar",
								"XDR" : "Special Drawing Rights",
								"XOF" : "CFA Franc BCEAO",
								"XPD" : "Palladium Ounce",
								"XPF" : "CFP Franc",
								"XPT" : "Platinum Ounce",
								"YER" : "Yemeni Rial",
								"ZAR" : "South African Rand",
								"ZMW" : "Zambian Kwacha",
								"ZWL" : "Zimbabwean Dollar"
							};

						});
	</script>

</body>
</html>
