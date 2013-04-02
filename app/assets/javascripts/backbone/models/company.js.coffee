class Maple.Models.Company extends Backbone.Model
  paramRoot: 'company'
  urlRoot: '/companies'
  
class Maple.Collections.CompaniesCollection extends Backbone.Collection
  model: Maple.Models.Company
  url: '/companies'
