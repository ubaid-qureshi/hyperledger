
query selectCommoditiesByOwner {
  description: "Select all commodities based on their owner"
  statement:
      SELECT org.loonycorn.trading.Commodity
          WHERE (owner == _$ownerId)
}

query selectCommoditiesWithHighQuantity {
  description: "Select commodities based on quantity"
  statement:
      SELECT org.loonycorn.trading.Commodity
          WHERE (quantity > _$quantity)
}