import pandas as pd
import os
import json
import argparse
import re
from parser import extract_answer

parser = argparse.ArgumentParser(description="Split parquet by data_source and export as jsonl.")
parser.add_argument('--input', type=str, default="data/math_testset/merged_testset_baseline_infered.parquet", help='输入parquet文件路径')
parser.add_argument('--output', type=str, default="./results/Qwen2.5-Math/math_eval", help='输出目录')
args = parser.parse_args()

input_path = args.input
output_dir = args.output

os.makedirs(output_dir, exist_ok=True)

# 读取 parquet 文件
df = pd.read_parquet(input_path)

# print(df)

def extract_solution(solution_str, data_name):
    """Extract the equation from the solution string."""

    answer_pattern = r'<my_answer>(.*?)</my_answer>'
    match = re.finditer(answer_pattern, solution_str, re.DOTALL)
    matches = list(match)
    
    matches = [m for m in matches if m.group(1).strip() != "and"]

    if len(matches) == 0:
        extracted_answer = extract_answer(solution_str, data_name)
    else:
        extracted_answer = matches[-1].group(1).strip()
        extracted_answer = extract_answer(extracted_answer, data_name)
    
    return extracted_answer

# 按 data_source 分组
for data_source, group in df.groupby("data_source"):
    # 你可以根据需要调整输出字段
    data_source_name = data_source.replace("math_testset_", ""  )
    os.makedirs(os.path.join(output_dir, data_source_name), exist_ok=True)
    output_path = os.path.join(output_dir, data_source_name, f"{data_source_name}.jsonl")
    with open(output_path, "w", encoding="utf-8") as fout:
        for _, row in group.iterrows():
            response_list = [row["responses"]] if isinstance(row["responses"], str) else row["responses"].tolist()
            pred_list = [extract_solution(resp, data_name=data_source) for resp in response_list]
            extra_info = json.loads(row["extra_info"])
            # 只导出需要的字段
            item = {
                "idx": row["id"],
                "question": row["prompt"][0]["content"],
                "code": response_list, # tbd
                "pred": pred_list,
            }
            for key in ["gt", "answer", "solution", "final_answer"]:
                if key in extra_info.keys():
                    item[key] = extra_info[key]
            fout.write(json.dumps(item, ensure_ascii=False) + "\n")
    print(f"导出 {data_source} 完成，样本数: {len(group)}，路径: {output_path}")