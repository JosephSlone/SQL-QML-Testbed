// A collection of database utility functions.


//============================================================================
// Lookup the value of the field (sourceColumn) in a database object matching
// a key in a keyColumn.
//
//  object --> dbObject to be searched
//  key --> what we are searching for
//  keyColumn --> where we are looking
//  sourceColumn --> what we are returning
//
// Note this is a binary search, (assumes the keyColumn is sorted)
//
// Joe Slone - 5/15/2017
//============================================================================


function lookup(object, key, keyColumn, sourceColumn) {
    var returnVal = "";
    var idx;

    var low = 0;
    var high = object.rowCount();
    var middle;
    var currentValue;


    // Binary Search

    while (low <= high) {
        middle = Math.floor(low + (high - low)/2);
        idx = object.index(middle, keyColumn, clientList);
        currentValue = object.data(idx, Qt.DisplayRole);

        if (currentValue === key)
        {
            var valueIdx = object.index(middle, sourceColumn, clientList);
            returnVal = object.data(valueIdx, Qt.DisplayRole);

            break;
        }
        else
        {

            if (currentValue < key)
            {
                low = middle + 1;
            }
            else
            {
                high = middle - 1;
            }
        }
    }

    return (returnVal);
}


//============================================================================
// Lookup the value of the field and return the actual row number
// in the database object.
//
//  object --> dbObject to be searched
//  key --> what we are searching for
//  keyColumn --> where we are looking
//
// Note this is a binary search, (assumes the keyColumn is sorted)
//
// Joe Slone - 5/15/2017
//============================================================================


function lookupIndex(object, key, keyColumn) {
    var returnVal = -1;
    var idx;
    var targetValue;

    var low = 0;
    var high = object.rowCount();
    var middle;
    var currentValue;

    // Binary Search

    while (low <= high) {
        middle = Math.floor(low + (high - low)/2);
        idx = object.index(middle, keyColumn, clientList);
        currentValue = object.data(idx, Qt.DisplayRole);

        if (currentValue === key)
        {
            console.log("currentValue: ", currentValue);
            console.log("middle:       ", middle);
            returnVal = middle;
            break;
        }
        else
        {

            if (currentValue < key)
            {
                low = middle + 1;
            }
            else
            {
                high = middle - 1;
            }
        }
    }

    return (returnVal);
}



//==========================================================
// Save changes for a database object,
//
// object --> dbObject to be saved to
// index --> record number to be saved to
// field --> field number to be saved in
// value --> value to be saved
//
//
// Joe Slone - 5/15/2017
//==========================================================


function saveChanges(object, index, field, value)
{
    var idx = object.index(index, field);


    console.log("saveChanges.Index: ",index);
    console.log("saveChanges.field: ", field);
    console.log("saveChanges.Value: ", value);

    object.setData(idx, value ,Qt.EditRole);
    object.submitAll();

}


