angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', 'User', "Bucket", "Budget", "ColorGenerator", 'ConstrainedSliderCollector', ($scope, $rootScope, $state, User, Bucket, Budget, ColorGenerator, ConstrainedSliderCollector)->
  console.log "Budget", User.getCurrentUser()
  $scope.buckets = []
  $scope.buckets_holder = []
  $scope.user_allocations = []
  $scope.loaded_buckets = 0
  $scope.allocatable_holder = 0

  $scope.setMinMax = (bucket)->
    if bucket.minimum_cents?
      bucket.minimum = parseFloat(bucket.minimum_cents) / 100
    else
      bucket.minimum = 0
    if bucket.maximum_cents?
      bucket.maximum = parseFloat(bucket.maximum_cents) / 100
    else
      bucket.maximum = 0
    bucket

  loadBucketFrames = ->
    buckets = Budget.getBudgetBuckets($state.params.budget_id).then (success)->
        for b, i in success
          b.user_allocation = 0
          b.color = ColorGenerator.makeColor(0.3,0.3,0.3,0,i * 1.25,4,177,65, i)
          b.allocations = []
          $scope.setMinMax(b)
          $scope.loadBucketAllocations(b)
      , (error)->
        console.log error
    buckets

  loadAllocatable = ->
    if User.getCurrentUser().accounts.length == 0
      console.log "No Accounts"
      $scope.allocatable = 0
      User.getCurrentUser().allocatable = 0
      return false
    for acc in User.getCurrentUser().accounts
      if acc.budget_id == parseFloat($state.params.budget_id)
        if acc.allocation_rights_cents?
          $scope.allocatable = acc.allocation_rights_cents

  $scope.loadBucketAllocations = (bucket)->
    b = bucket
    Bucket.getBucketAllocations(b.id).then (success)->
      sum = 0
      if success.length > 0
        for a in success
          b.allocations.push a
          if a.user_id == User.getCurrentUser().id
            b.user_allocation = a.amount
      b.user_allocation
        #b.allocations = success
    .then (amount)->
      $scope.buckets_holder.push b
      $scope.allocatable_holder += parseInt(amount, 10)
      $scope.loaded_buckets++
      if $scope.loaded_buckets == $scope.loading_counter
        $scope.allocatable += $scope.allocatable_holder
        $scope.buckets = $scope.buckets_holder

  loadAllocatable()
  loadBucketFrames().then((success)->
    $scope.loading_counter = success.length
  )

  $scope.prepareUserAllocations = ()->
    allocations = []
    sum = 0
    for bucket in $scope.buckets
      #eventually a prob when allocations to same bucket.
      for allocation, i in bucket.allocations
        if allocation.user_id == User.getCurrentUser().id
          sum += allocation.amount
          allocation.label = "#{bucket.name}"
          allocation.bucket_color = bucket.color
          if allocation.amount > 0
            allocations.push allocation

    unallocated = $scope.allocatable - sum 
    allocations.push {user_id: undefined, label: "Unallocated", amount: unallocated, bucket_color: "#ececec" }
    $scope.user_allocations = allocations.reverse()

  $scope.chart_options = 
    segmentShowStroke : true
    segmentStrokeColor : "#fff"
    animation : false,

  $scope.prepareChart = ()->
    ch_vals = []
    angular.forEach($scope.user_allocations, (allocation)->
      ch_val = { value: allocation.amount, color: allocation.bucket_color }
      ch_vals.push ch_val
    )
    $scope.chart = ch_vals

  $scope.$watch 'user_allocations', (n, o)->
    if n != o
      $scope.prepareChart()

  $rootScope.channel.bind('bucket_created', (bucket) ->
    setMinMax(bucket.bucket)
    $scope.buckets.unshift bucket.bucket
    $scope.$apply()
  )

  $rootScope.channel.bind('bucket_updated', (bucket) ->
    for i in [0...$scope.buckets.length]
      bk = $scope.buckets[i]
      if bk.id == bucket.bucket.id
        $scope.buckets[i] = bucket.bucket
        setMinMax($scope.buckets[i])
    $scope.$apply()
  )
])
