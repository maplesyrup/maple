class Maple.Models.Company extends Backbone.Model
  paramRoot: 'company'

class Maple.Collections.CompaniesCollection extends Backbone.Collection
  model: Maple.Models.Company
  url: '/companies'
