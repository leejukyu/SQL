# 주의사항
## select
- 칼럼명을 새로 명명할 경우 띄어쓰기, 숫자로 시작하는 단어, 특수문자가 포함된 단어는 올 수 없음
- 단, 컬럼명을 큰따옴표로 감싸준 경우에는 모든 값이 다 가능(비추)
## where
- and와 or를 함께 쓸때는, 반드시 ()로 의미 단위끼리 묶음
## group by
- select절에 등장한 컬럼이 group by에 모두 명시되지 않은 경우(집계함수 제외)
## having
- where : 집계 전 데이터를 필터링
- having : 집계 후 데이터를 필터링(집계함수 만!! 올 수 있음)
## join
- 조인 키에 특정 테이블에 의도치 않게 중복값이 있으면 조인 결과 중복이 발생(알려주지 않음) -> unique 확인
- join 뒤에 where절 올 때 조심
