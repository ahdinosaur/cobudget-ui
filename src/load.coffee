
module.exports = (flux) ->
  Budgets = flux.stores.Budgets
  Nav = flux.stores.Nav

  # once budgets are loaded, default
  # path to first budget
  Budgets.once "change", ->
    if Nav.path == ""
      flux.actions.nav.navigate
        name: "budget"
        params:
          budgetId: Budgets.budgets[0].id
  Budgets.load()
