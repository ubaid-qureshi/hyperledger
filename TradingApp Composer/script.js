
/**
 * Track the trade of a commodity from one trader to another
 * @param {org.loonycorn.trading.Sell} trade - the trade to be processed
 * @transaction
 */
async function sellCommodity(tx) { 

    tx.commodity.owner = tx.newOwner;
    const assetRegistry = await      getAssetRegistry('org.loonycorn.trading.Commodity');

    const saleNotification = getFactory().newEvent('org.loonycorn.trading', 'SaleNotification');
    saleNotification.commodity = tx.commodity;
    emit(saleNotification);

    await assetRegistry.update(tx.commodity);
}

/**
 * Remove commodities based on quantity
 * @param {org.loonycorn.trading.RemoveCommodities} remove - the remove to be processed
 * @transaction
 */
async function removeCommodities(tx) { 

    const assetRegistry = await getAssetRegistry('org.loonycorn.trading.Commodity');
    const results = await query('selectCommoditiesWithHighQuantity',{ "quantity": tx.quantity});

    results.forEach(async trade => {
        const removeNotification = getFactory().newEvent('org.loonycorn.trading', 'RemoveNotification');
        removeNotification.commodity = trade;
        emit(removeNotification);

        await assetRegistry.remove(trade);
    });
}

/**
 * Remove commodities based on their owner
 * @param {org.loonycorn.trading.RemoveCommoditiesByOwner} remove - the remove to be processed
 * @transaction
 */
async function removeCommoditiesByOwner(tx) { 

    const assetRegistry = await getAssetRegistry('org.loonycorn.trading.Commodity');
    const results = await query('selectCommoditiesByOwner',{ "ownerId": tx.ownerId});

    results.forEach(async commodity => {
        const removeNotification = getFactory().newEvent('org.loonycorn.trading', 'RemoveNotification');
        removeNotification.commodity = commodity;
        emit(removeNotification);

        await assetRegistry.remove(commodity);
    });
}