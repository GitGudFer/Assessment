# We're going to use mainly pandas methods to identify and fill the missing values, remove duplicates, and remove invalid characters if found
import numpy as np
import pandas as pd

# First, let's explore the dataset a little
transactions=pd.read_csv("transactions data set.csv")
pd.set_option('display.max_rows', None) 
transactions # we can explore the whole dataset visually
transactions.info()
transactions.isnull().sum() # or with methods, which let us identify 13 NAs in 'CLIENT_NAME', 14 in 'STORE_NAME' and 14 in "PRODUCT_NAME"

# Let's see how many rows we have to correct
print(len(transactions) - len(transactions.dropna())) # 35 filas con valores faltantes
print(len(transactions) - len(transactions.drop_duplicates())) # 20 filas duplicadas

# Ordering the dataset
transactions.sort_values(["CLIENT_ID", "STORE_ID", "PRODUCT_ID"], ignore_index=True, inplace=True)
transactions #now we can further explore it already sorted

# From now on, we'll just leave the original ordered and make copies
transactions2 = transactions.drop_duplicates()
len(transactions2)
transactions2.sort_values(["CLIENT_ID", "STORE_ID", "PRODUCT_ID"], ignore_index=True, inplace=True) # sorting again to avoid having missing indexes

# Now let's identify and fill missing values
missingrows = np.where(transactions2.isna().any(axis=1))
transactions2.loc[missingrows] # this lets us see just the rows with missing values


# While we could fill every missing value individually, the missing values have a pattern, so using functions is more convenient and scalable
# in this case, I made a function that evaluates row by row
transactions3 = transactions2 

def fill_client_name(row):
    if pd.isna(row['CLIENT_NAME']):
        return 'Client_' + str(row['CLIENT_ID'])
    else:
        return row['CLIENT_NAME']

def fill_store_name(row):
    if pd.isna(row['STORE_NAME']):
        return 'Store_' + str(row['STORE_ID'])
    else:
        return row['STORE_NAME']

def fill_product_name(row):
    if pd.isna(row['PRODUCT_NAME']):
        return 'Product_' + str(row['PRODUCT_ID'])
    else:
        return row['PRODUCT_NAME']

# the previous functions take the datasets' rows as arguments, provided by the "axis=1" argument in the apply method. 
# the functions first evaluate if the value is NaN, and if that yields true, it changes the value to the correct construction. Is the value is not NaN, it just returns the value stored

transactions3['CLIENT_NAME'] = transactions3.apply(fill_client_name, axis=1)
transactions3['STORE_NAME'] = transactions3.apply(fill_store_name, axis=1)
transactions3['PRODUCT_NAME'] = transactions3.apply(fill_product_name, axis=1)

transactions3.loc[missingrows]

# Finally, exploring the rows that originally had missing values, we can see they have been correctly filled
