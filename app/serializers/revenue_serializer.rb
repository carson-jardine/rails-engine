class RevenueSerializer
  def self.revenue(object)
     {
       "data": {
         "id": nil,
         "attributes": {
           "revenue": object.round(2)
         }
       }
     }
   end
end
