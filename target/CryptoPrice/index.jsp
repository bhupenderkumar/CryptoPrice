<!DOCTYPE html>
<html>

<head>
<title>Crypto Currency Price</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/main.css">
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
</head>
<script src="js/angular.min.js"></script>
<script type="text/javascript" src="js/ngStorage.min.js"></script>
<script src="js/index.js"></script>
<body>

	<div ng-app="cryptoPrice">
		<div ng-controller="priceCtrl">
			<div class="loading" ng-if="crypto==undefined">Loading&#8230;</div>
			<div ng-if="crypto!=undefined ">
				Testing Price controller ...Total Price <B>{{totalPrice}}</B> <br>
				<div class="col-lg-12 form-group">
					<div class="col-lg-4 text-muted">CryptoCurrency Name :</div>
					<div class="col-lg-8">
						<select class="form-control"
							ng-options="item as item.name for item in crypto track by item.id"
							ng-model="userCrypto.crypto"><option>Select</option>
						</select>
					</div>
				</div>
				<div class="col-lg-12 form-group">
					<div class="col-lg-4 text-muted">In how much quantity</div>
					<div class="col-lg-8">
						<input type="text" class="form-control"
							ng-model="userCrypto.quantity">
					</div>
				</div>
				<div class="col-lg-12 form-group">
					<div class="col-lg-4 text-muted">In which Currency you want
						your price</div>
					<div class="col-lg-8">
						<select ng-model="userCrypto.currency" class="form-control">
							<option ng-repeat="(key,val) in currencies" value="{{val}}"
								selected="selected">{{val}}-{{key}}</option>
						</select>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="col-lg-3"></div>
					<div class="col-lg-9">
						<input class="btn btn-primary" type="button" value="Add"
							ng-click="addCrypto()" />
					</div>
				</div>

			</div>
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
</body>
</html>
