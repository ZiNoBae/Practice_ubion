import random

# 게임 보드 생성 함수
def create_board(board_size, num_mines):
    # 지뢰를 놓을 좌표를 랜덤으로 선택
    mines = random.sample(range(board_size**2), num_mines)
    board = []
    for i in range(board_size):
        row = []
        for j in range(board_size):
            # 선택한 좌표가 지뢰면 1, 아니면 0으로 표시
            if i * board_size + j in mines:
                row.append(1)
            else:
                row.append(0)
        board.append(row)
    return board

# 주변 지뢰 개수 계산 함수
def count_adjacent_mines(board, i, j):
    count = 0
    for x in range(max(0, i-1), min(len(board), i+2)):
        for y in range(max(0, j-1), min(len(board), j+2)):
            count += board[x][y]
    return count

# 게임 실행 함수
def play_game():
    # 보드 생성
    board_size = 5
    num_mines = 5
    board = create_board(board_size, num_mines)
    print("지뢰찾기 게임을 시작합니다. 보드의 크기는 %d x %d이며, 지뢰의 개수는 %d개입니다." % (board_size, board_size, num_mines))

    # 게임 진행
    game_over = False
    while not game_over:
        for i in range(board_size):
            row = []
            for j in range(board_size):
                if board[i][j] == -1:
                    print("X", end="")
                elif board[i][j] == 1:
                    print("*", end="")
                else:
                    count = count_adjacent_mines(board, i, j)
                    print(count, end="")
                row.append(board[i][j])
            print("")
        print("좌표를 입력하세요. (예: 1 2)")
        x, y = map(int, input().split())
        if board[x][y] == 1:
            print("지뢰를 밟았습니다. 게임 오버!")
            game_over = True
        else:
            board[x][y] = -1
            if sum(row.count(-1) for row in board) == num_mines:
                print("지뢰를 모두 찾았습니다. 게임 클리어!")
                game_over = True

play_game()
