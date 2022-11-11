#!/usr/bin/env python
# coding: utf-8

# In[1]:


# Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #Adjusts config of plots

df = pd.read_csv(r'E:\Scripts and Docs\Python Movie Analysis\movies.csv')


# In[2]:


#drop null values
df = df.dropna()


# In[3]:


#determine if any data is missing

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))


# In[4]:


# View Data types
df.dtypes


# In[5]:


#Change Data types to remove decimal places
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')
# remove decimal places from budget, votes, and gross
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))


# In[6]:


df.head()


# In[7]:


#create column to reflect correct year
# Release date column is in Full month name, Year, Country
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)

df


# In[8]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[ ]:


pd.set_option('display.max_rows',None)


# In[ ]:


# Remove/drop duplicates
df['company'].sort_values(ascending=False)


# In[ ]:


#budget and/or company high correlation
#scatterplot w/ budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget vs Gross Earnings')


plt.xlabel('Gross Earnings')
plt.ylabel('Budget')
#plt.show()


# In[ ]:


# Plot of budget v gross using seaborn

sns.regplot(x='budget', 
            y='gross',
            data = df, 
            scatter_kws={"color":"red"}, 
            line_kws={"color":"green"})


# In[ ]:


#Pearson, kendall, spearman correlations will provide different results
df.corr(method = 'spearman') #default correlation - Pearson

#High correlation between budget + gross


# In[ ]:


correlation_matrix = df.corr(method = 'pearson')

sns.heatmap(correlation_matrix,annot=True)

plt.title('Corerlation Matrix using Pearson Correlation: Numeric Features')


plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[ ]:


correlation_matrix = df.corr(method = 'kendall')

sns.heatmap(correlation_matrix,annot=True)

plt.title('Corerlation Matrix using Kendall Correlation: Numeric Features')


plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[ ]:


correlation_matrix = df.corr(method = 'spearman')

sns.heatmap(correlation_matrix,annot=True)

plt.title('Corerlation Matrix using Spearman Correlation: Numeric Features')


plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[ ]:


df_numerized = df

for col_name in df_numerized.columns:
    if (df_numerized[col_name].dtype =='object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes 
        
df_numerized


# In[ ]:


correlation_matrix_2 = df_numerized.corr(method = 'pearson')

sns.heatmap(correlation_matrix_2,annot=True)

plt.title('Corerlation Matrix 2 using Pearson Correlation: Numeric Features')


plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[ ]:


df_numerized.corr()


# In[ ]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[ ]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[ ]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


# Votes and budget have the highest correlation to gross earnings

