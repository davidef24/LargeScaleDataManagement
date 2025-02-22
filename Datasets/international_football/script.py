import pandas as pd
import random

def remove_random_rows(input_file, output_file, num_rows=40000):
    # Read the CSV file into a DataFrame
    df = pd.read_csv(input_file)
    
    # Ensure that we don't remove more rows than exist in the DataFrame
    num_rows = min(num_rows, len(df))
    
    # Randomly select indices to drop
    drop_indices = random.sample(range(len(df)), num_rows)
    
    # Drop the selected rows
    df = df.drop(drop_indices).reset_index(drop=True)
    
    # Save the modified DataFrame to a new CSV file
    df.to_csv(output_file, index=False)

# Example usage
input_file = "matches.csv"  # Replace with your actual input file name
output_file = "matches_filtered.csv"  # Output file name
remove_random_rows(input_file, output_file)