/*
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => ���̵�, �н�����, �̸�
              Out => returnVal(����:1, ����:0) */
/*Java���� �Է��� ������ ���� ���Ķ���� ���� �� ���� �������θ� ��ȯ�ϱ� ����
�ƿ��Ķ���� ����*/
create or replace procedure ChatingInsert(
    idx1 number,
    id varchar2,
    chat varchar2
        )
is
begin
    --���Ķ���͸� ����  insert�������� �ۼ�
    insert into chating (idx,id,chat)
        values(chat_serial_num.nextval,p_pass,p_name);
        
    if sql%found then
        --�Է��� ����ó�� �Ǿ��ٸ� �Էµ� ���� ������ ���´�.
        returnVal :=sql%rowcount;
        --���� ��ȭ�� �������Ƿ� �ݵ�� Ŀ���ؾ� �Ѵ�.
        commit;
    else
        --�Է¿� �����ϸ� 0�� ��ȯ�Ѵ�.
        returnVal :=0;
    end if;
    /* (���ν����� ������ return ���� �ƿ��Ķ���Ϳ� ���� �Ҵ��ϱ⸸ �ϸ� �ڵ�����
        ��ȯ�Ѵ�. */
end;
/

set serveroutput on;

var i_result varchar2(10);
execute MyMemberInsert('pro03','1234','���ν���3',:i_result);
execute MyMemberInsert('pro02','2222','���ν���2',:i_result);
print i_result;

select * from member;