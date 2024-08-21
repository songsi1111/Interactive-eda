from flask import Flask, request, render_template, send_file
import subprocess
import os
import json

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process', methods=['POST'])

def process():
    user_input = request.form['user_input']

    # 将用户输入保存到input.rs文件
    with open('input.rs', 'w') as f:
        f.write(user_input)

    # 调用C++程序处理input.rs文件
    process = subprocess.Popen(['./main'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr:
        return f"Error: {stderr.decode()}"

    # 假设C++程序生成了output.dot文件
    dot_file = 'ast.dot'
    png_file = 'ast.png'

    # 使用Graphviz将.dot文件转换为.png文件
    subprocess.run(['dot', '-Tpng', dot_file, '-o', png_file])

    # 检查生成的PNG文件
    if not os.path.exists(png_file):
        return "Error: PNG file not generated"

    # 返回处理后的文本输出和生成的PNG文件路径
    return render_template('index.html', output=stdout.decode(), image_file=png_file)

@app.route('/display_image')
def display_image():
    # 发送生成的PNG图片给前端
    return send_file('ast.png', mimetype='image/png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
