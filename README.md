## iOS 커리어 스타터 캠프

### 계산기 프로젝트 저장소

#### UML
![image](https://user-images.githubusercontent.com/90945013/140878044-b9e2bb63-cc92-4a4c-9039-1ff1c39eb272.png)


#### 의도한 점, 고민한 점

1. 배열 VS 단방향 연결리스트
  - 요구사항에 따른 현재 사용하는 기능은 enQueue(삽입), deQueue(삭제), removeAll(모두삭제) 입니다.
  - enQueue는 뒤에 삽입을 하는 것이므로 단방향 연결리스트로 구현하게 되면 처음부터 끝까지 순회를 한 후 마지막에 삽입을 해주어야해서 배열보다 성능이 좋지 않습니다.
  - deQueue는 맨 앞을 삭제 하기 때문에 배열을 사용하여 맨 앞을 삭제하면 뒤에 있는 요소들이 모두 한칸씩 앞으로 오게 되어 성능이 좋지 않다. 그래서  삭제에는 단방향 연결 리스트가 유리합니다..
  - 큐 모두삭제는 두 개다 비슷한 성능을 낼 것으로 보입니다.
  - ***단방향 연결리스트 보완을 하여 사용하기로 했습니다. 단반향 연결리스트에 front만 사용하는 것이 아니라 rear도 사용하여 enQueue(삽입)을 할 때는 rear의 다음 노드에 연결할 수 있도록 하여 기존에 front부터 마지막까지 탐색하던 시간을 줄였습니다. ***


2. 클래스 VS 구조체 사용
  - Node는 클래스로 작성하였고 LinkedList는 구조체로 작성하였습니다.
  - Node를 클래스로 작성한 이유는 우선 Node 타입 안에 Node타입의 재귀적인 저장프로퍼티가 있기 때문입니다. Node안에 Node가 있는데 struct로 하면 값타입 안에 값타입 안에 값타입 안에.....값타입이 되면 상위의 노드가 삭제되면 모두 삭제 되지 않을까 생각했습니다. 
  - LinkedList를 구조체로 사용한 이유는 class처럼 상속이 필요하거나, 참조타입으로 선언하지 않아도 되기 때문입니다.


## STEP2
#### 의도한 점, 고민한 점

1. 고차함수 적극활용 요구사항에 고차함수를 적극 활용하라는 요구사항이 있어 조금은 과하게? 고차함수를 활용하였습니다. 애초에 제가 작성한 코드가 어떤 구성을 가지고 있는지에 대해 알고 있으면 오히려 코드가 간결해서 이해하기는 쉬울 것 같은데 이 코드를 처음 본 사람은 한눈에 이해하기 어려울수도 있다고 생각했습니다. 그래도 나름 보기에 최대한 쉽도록 고차함수를 사용해 보았습니다. 

2. 열거형 ExpressionParser 사용 제공된 UML에는 ExpressionParser에는 case는 없고 메서드만 있습니다. 그래서 static 을 붙여 타입메서드로 활용될 수 있도록 하였습니다. 열거형은 인스턴스가 없으니 타입 메서드를 활용하여 필요할 때 부담 없이 사용할 수 있는 장점을 가졌다고 생각합니다. 

3. 열거형 Operator 타입 사용 구조체 Formula 의 프로퍼티의 연산자 타입을 처음에는 Character 로 했었는데 operator 타입을 이용하여 프로그램 내에서 데이터를 전달할 때 operator 타입으로 던져 줌으로써 정해놓은 값만 사용할 수 있게 하였고 코드의 가독성도 좋도록 하여 enum의 장점을 살릴 수 있도록 하였습니다. 

4. 요구사항 및 UML 요구사항에 맞춘 최소한의 기능만 구현 하였으며, UML에 만족하는 코드로 구현해보았습니다. UML에 맞춰 구현하는 것은 처음이어서 UML에 있는 메서드의 기능을 이해하고 구현을 하는데에 시간이 조금 걸렸지만 좋은 경험이었습니다. 

5. 코드 컨벤션 선언부를 적어 주고 구현부를 들어갈 때 한 줄을 띄워 주었습니다. return할 값이 있을 때는 구현부에서 닫는 괄호 하나로 끝날 때에는 바로 아래줄에 적어주었고, 괄호로 끝나지 않으면 return을 한줄 띄우고 적어주었습니다. 또한 한 줄에 코드가 너무 길어지면 중간에 끊어서 다음 줄로 넘어갈 수 있도록 하였습니다.

