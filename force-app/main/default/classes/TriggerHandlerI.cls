public interface TriggerHandlerI {
  void beforeInsert();
    void afterInsert();
    void beforeUpdate();
    void afterUpdate();
    void beforeDelete();
    void afterDelete();
}